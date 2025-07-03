//
//  APIConfiguration.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation
import Network
import Combine

class APIConfiguration: ObservableObject {
    static let shared = APIConfiguration()
    
    @Published var currentEnvironment: APIEnvironment = .production
    @Published var isDetecting = false
    @Published var isReachable = false
    @Published var lastDetectionDate: Date?
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    var baseURL: URL {
        return URL(string: currentEnvironment.baseURL)!
    }
    
    private init() {
        currentEnvironment = .local
        clearSavedEnvironment()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func performEnvironmentDetection() async -> APIEnvironment {
        #if DEBUG
        let isDockerEnvironment = ProcessInfo.processInfo.environment["AUTO_MIGRATE"] != nil
        let localAvailable = await isServerReachable(url: "http://localhost:8080")
        
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
            isReachable = await isServerReachable(url: environment.baseURL)
            if !isReachable {
                print("Warning: \(environment.rawValue) server is not reachable")
            }
        }
        
        await MainActor.run {
            currentEnvironment = environment
            saveEnvironment()
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
            isReachable = await testCurrentEnvironment()
            await MainActor.run {
                print("Current environment reachable: \(isReachable)")
            }
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
                self.isReachable = await self.isServerReachable(url: environment.baseURL)
                promise(.success(self.isReachable))
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
    
    func clearSavedEnvironment() {
        UserDefaults.standard.removeObject(forKey: environmentKey)
    }
}
