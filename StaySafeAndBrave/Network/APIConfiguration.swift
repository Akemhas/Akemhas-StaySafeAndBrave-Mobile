//
//  APIConfiguration.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation

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
            return "http://127.0.0.1:8080" // Same port, but running in Docker
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
}

class APIConfiguration: ObservableObject {
    static let shared = APIConfiguration()
    
    @Published var currentEnvironment: APIEnvironment = {
        #if DEBUG
        return .local
        #else
        return .production
        #endif
    }()
    
    var baseURL: URL {
        return URL(string: currentEnvironment.baseURL)!
    }
    
    private init() {}
    
    // MARK: - Environment Detection
    
    /// Auto-detect environment based on build configuration and settings
    func autoDetectEnvironment() {
        #if DEBUG
        // In debug mode, we can try to detect if we're using Docker
        // by checking if AUTO_MIGRATE env var is set (Docker compose sets this)
        if ProcessInfo.processInfo.environment["AUTO_MIGRATE"] != nil {
            currentEnvironment = .docker
        } else {
            currentEnvironment = .local
        }
        #else
        currentEnvironment = .production
        #endif
    }
    
    // MARK: - Manual Environment Switching (for debugging)
    
    func switchTo(_ environment: APIEnvironment) {
        currentEnvironment = environment
        print("🔄 Switched API environment to: \(environment.rawValue)")
        print("🌐 Base URL: \(environment.baseURL)")
    }
    
    // MARK: - Debug Information
    
    var debugInfo: String {
        return """
        Current Environment: \(currentEnvironment.rawValue)
        Base URL: \(currentEnvironment.baseURL)
        Secure: \(currentEnvironment.isSecure ? "Yes (HTTPS)" : "No (HTTP)")
        Description: \(currentEnvironment.description)
        """
    }
}

// MARK: - UserDefaults Extension for Persistence

extension APIConfiguration {
    private var environmentKey: String { "selectedAPIEnvironment" }
    
    func saveEnvironment() {
        UserDefaults.standard.set(currentEnvironment.rawValue, forKey: environmentKey)
    }
    
    func loadSavedEnvironment() {
        if let savedRawValue = UserDefaults.standard.string(forKey: environmentKey),
           let savedEnvironment = APIEnvironment(rawValue: savedRawValue) {
            currentEnvironment = savedEnvironment
        }
    }
}
