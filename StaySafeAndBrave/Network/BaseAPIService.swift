//
//  BaseAPIService.swift (Improved Error Handling)
//  StaySafeAndBrave
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// Add this struct to handle Vapor's error format
struct VaporErrorResponse: Decodable {
    let error: Bool?
    let reason: String?
    
    var displayMessage: String {
        return reason ?? "Unknown error occurred"
    }
}

class BaseAPIService: ObservableObject {
    
    // Use centralized configuration
    private let apiConfig = APIConfiguration.shared
    
    var baseURL: URL {
        return apiConfig.baseURL
    }
    
    internal func createRequest(
        endpoint: String,
        method: HTTPMethod,
        body: Data? = nil
    ) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body
        
        #if DEBUG
        print("🌐 API Request: \(method.rawValue) \(url)")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("📤 Request Body: \(bodyString)")
        }
        #endif
        
        return request
    }
    
    internal func handleResponse<T: Decodable>(
        _ type: T.Type,
        data: Data,
        response: URLResponse
    ) throws -> T {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: -1, message: "No HTTP response")
        }
        
        #if DEBUG
        print("📡 API Response: \(httpResponse.statusCode)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Response Data: \(responseString)")
        }
        #endif
        
        // Check if status code is successful
        guard 200...299 ~= httpResponse.statusCode else {
            let errorMessage: String?
            
            // Try to parse different error response formats
            if let vaporError = try? JSONDecoder().decode(VaporErrorResponse.self, from: data) {
                errorMessage = vaporError.displayMessage
                print("🔍 Parsed Vapor error: \(errorMessage ?? "Unknown")")
            } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                errorMessage = errorResponse.displayMessage
                print("🔍 Parsed standard error: \(errorMessage ?? "Unknown")")
            } else if let responseString = String(data: data, encoding: .utf8), !responseString.isEmpty {
                errorMessage = responseString
                print("🔍 Raw error response: \(errorMessage ?? "Unknown")")
            } else {
                errorMessage = nil
                print("🔍 No error message could be parsed")
            }
            
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        // Handle empty responses (for DELETE operations)
        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        }
        
        // Decode the response
        do {
            let decoded = try JSONDecoder.apiDecoder.decode(T.self, from: data)
            return decoded
        } catch {
            print("❌ Decoding error: \(error)")
            if let decodingError = error as? DecodingError {
                print("❌ Detailed decoding error: \(decodingError)")
            }
            throw APIError.decodingError(error)
        }
    }
    
    internal func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let request = createRequest(endpoint: endpoint, method: method, body: body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return try handleResponse(responseType, data: data, response: response)
        } catch let urlError as URLError {
            print("❌ Network error: \(urlError)")
            throw APIError.networkError(urlError)
        } catch let apiError as APIError {
            print("❌ API error: \(apiError)")
            throw apiError
        } catch {
            print("❌ Unknown error: \(error)")
            throw APIError.unknown(error)
        }
    }
}
