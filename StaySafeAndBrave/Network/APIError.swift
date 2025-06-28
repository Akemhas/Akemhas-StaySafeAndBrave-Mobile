//
//  APIError.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation

// MARK: - API Error Types

enum APIError: Error, LocalizedError {
    case invalidResponse(statusCode: Int, message: String?)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(URLError)
    case invalidURL
    case noData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse(let statusCode, let message):
            return "Server error (\(statusCode)): \(message ?? "Unknown server error")"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    var isNetworkError: Bool {
        switch self {
        case .networkError:
            return true
        default:
            return false
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .invalidResponse(let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
}

// MARK: - Error Response from Backend

struct ErrorResponse: Decodable {
    let message: String?
    let error: String?
    
    var displayMessage: String {
        return message ?? error ?? "Unknown error occurred"
    }
}

// MARK: - Empty Response for DELETE operations

struct EmptyResponse: Decodable {
    // Empty struct for DELETE responses that don't return data
}
