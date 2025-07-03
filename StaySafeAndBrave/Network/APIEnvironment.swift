//
//  APIEnvironment.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

enum APIEnvironment: String, CaseIterable {
    case local = "Local Development"
    case docker = "Local Docker"
    case staging = "Staging"
    case production = "Production"
    
    var baseURL: String {
        switch self {
        case .local:
            return "http://localhost:8080"
        case .docker:
            return "http://localhost:8080"
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
