//
//  APIConfiguration.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation
import Network
import Combine

enum APIEnvironment: String, CaseIterable {
    case local = "Local Development"
    case docker = "Local Docker"
    case staging = "Staging"
    case production = "Production"
    
    var baseURL: String {
        switch self {
        case .local:
            return "http://127.0.0.1:8080"
        case .docker:
            return "http://127.0.0.1:8080"
        case .staging:
            return "https://mic-2025-staysafeandbrave.onrender.com"
        case .production:
            return "https://mic-2025-staysafeandbrave.onrender.com"
        }
    }
    
    var description: String {
        switch self {
        case .local:
            return "Local Vapor server (swift run)"
        case .docker:
            return "Local Docker container"
        case .staging:
            return "Staging server on Render"
        case .production:
            return "Production server on Render"
        }
    }
    
    var isSecure: Bool {
        return baseURL.hasPrefix("https")
    }
    
    var isLocal: Bool {
        return self == .local || self == .docker
    }
}

class APIConfiguration: ObservableObject {
    static let shared = APIConfiguration()
    
    @Published var currentEnvironment: APIEnvironment = .production
    @Published var isDetecting = false
    @Published var lastDetectionDate: Date?
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    var baseURL: URL {
        return URL(string: currentEnvironment.baseURL)!
    }
    
    private init() {
        loadSavedEnvironment()
        startNetworkMonitoring()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.autoDetectEnvironmentIfNeeded()
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    func autoDetectEnvironment() async {
        await MainActor.run {
            isDetecting = true
        }
        
        let detectedEnvironment = await performEnvironmentDetection()
        
        await MainActor.run {
            if detectedEnvironment != currentEnvironment {
                currentEnvironment = detectedEnvironment
                saveEnvironment()
            }
            lastDetectionDate = Date()
            isDetecting = false
        }
    }
    
    private func autoDetectEnvironmentIfNeeded() {
        // Only auto-detect every 30 seconds to avoid spam
        if let lastDetection = lastDetectionDate,
           Date().timeIntervalSince(lastDetection) < 30 {
            return
        }
        
        Task {
            await autoDetectEnvironment()
        }
    }
    
    private func performEnvironmentDetection() async -> APIEnvironment {
        #if DEBUG
        let isDockerEnvironment = ProcessInfo.processInfo.environment["AUTO_MIGRATE"] != nil
        let localAvailable = await isServerReachable(url: "http://127.0.0.1:8080")
        
        if localAvailable {
            return isDockerEnvironment ? .docker : .local
        } else {
            return .staging
        }
        #else
        return .production
        #endif
    }
    
    private func isServerReachable(url: String, timeout: TimeInterval = 3.0) async -> Bool {
        guard let url = URL(string: url) else { return false }
        
        do {
            let request = URLRequest(url: url, timeoutInterval: timeout)
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode > 0 && httpResponse.statusCode != 404
            }
            return false
        } catch {
            return false
        }
    }
    
    func testCurrentEnvironment() async -> Bool {
        return await isServerReachable(url: currentEnvironment.baseURL)
    }
    
    func findAvailableEnvironment(priorityOrder: [APIEnvironment]? = nil) async -> APIEnvironment {
        let environments = priorityOrder ?? [.local, .docker, .staging, .production]
        
        for environment in environments {
            if await isServerReachable(url: environment.baseURL) {
                return environment
            }
        }
        
        return .production
    }
    
    func switchTo(_ environment: APIEnvironment, validate: Bool = false) async {
        if validate {
            let isReachable = await isServerReachable(url: environment.baseURL)
            if !isReachable {
                print("Warning: \(environment.rawValue) server is not reachable")
            }
        }
        
        await MainActor.run {
            currentEnvironment = environment
            saveEnvironment()
        }
    }
    
    func switchToAvailableEnvironment() async {
        let available = await findAvailableEnvironment()
        await switchTo(available)
    }
    
    func handleAppDidBecomeActive() {
        Task {
            await autoDetectEnvironment()
        }
    }
    
    func handleAppLaunch() {
        Task {
            await autoDetectEnvironment()
        }
    }
    
    var debugInfo: String {
        let reachabilityStatus = lastDetectionDate != nil ?
            "Last checked: \(DateFormatter.localizedString(from: lastDetectionDate!, dateStyle: .none, timeStyle: .medium))" :
            "Not checked yet"
        
        return """
        Current Environment: \(currentEnvironment.rawValue)
        Base URL: \(currentEnvironment.baseURL)
        Secure: \(currentEnvironment.isSecure ? "Yes (HTTPS)" : "No (HTTP)")
        Description: \(currentEnvironment.description)
        Detection Status: \(isDetecting ? "Detecting..." : "Idle")
        \(reachabilityStatus)
        """
    }
    
    // Non-async wrapper methods for SwiftUI
    func testCurrentEnvironmentAsync() {
        Task {
            let isReachable = await testCurrentEnvironment()
            await MainActor.run {
                print("Current environment reachable: \(isReachable)")
            }
        }
    }
    
    func switchToAvailableEnvironmentAsync() {
        Task {
            await switchToAvailableEnvironment()
        }
    }
    
    func switchToAsync(_ environment: APIEnvironment, validate: Bool = false) {
        Task {
            await switchTo(environment, validate: validate)
        }
    }
    
    var environmentDetectionPublisher: AnyPublisher<APIEnvironment, Never> {
        $currentEnvironment
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    func serverReachabilityPublisher(for environment: APIEnvironment) -> AnyPublisher<Bool, Never> {
        Future { promise in
            Task {
                let isReachable = await self.isServerReachable(url: environment.baseURL)
                promise(.success(isReachable))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension APIConfiguration {
    private var environmentKey: String { "selectedAPIEnvironment" }
    
    func saveEnvironment() {
        UserDefaults.standard.set(currentEnvironment.rawValue, forKey: environmentKey)
    }
    
    func loadSavedEnvironment() {
        if let savedRawValue = UserDefaults.standard.string(forKey: environmentKey),
           let savedEnvironment = APIEnvironment(rawValue: savedRawValue) {
            currentEnvironment = savedEnvironment
        } else {
            #if DEBUG
            currentEnvironment = .local
            #else
            currentEnvironment = .production
            #endif
        }
    }
}
