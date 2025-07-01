//
//  UserAPIService.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

class UserAPIService: BaseAPIService {
    
    static let shared = UserAPIService()
    
    private override init() {
        super.init()
    }
    
    private struct Endpoints {
        static let register = "/users/register"
        static let login = "/users/login"
        static let users = "/users/json"
        static func user(id: UUID) -> String {
            return "/users/\(id.uuidString)"
        }
    }
    
    func register(data: UserRegistrationDTO) async throws -> AuthResponseDTO {
        print("Registering new user: \(data.email)")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            let userResponse = try await performRequest(
                endpoint: Endpoints.register,
                method: .POST,
                body: body,
                responseType: UserResponseDTO.self
            )
            
            print("Registration API successful, user: \(userResponse.name ?? "Unknown")")
            
            return userResponse.toAuthResponse()
            
        } catch let apiError as APIError {
            print("API registration error: \(apiError)")
            throw apiError
        } catch {
            print("Failed to encode registration data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    func login(email: String, password: String) async throws -> AuthResponseDTO {
        print("Logging in user: \(email)")
        
        let loginData = UserLoginDTO(email: email, password: password)
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(loginData)
            
            let userResponse = try await performRequest(
                endpoint: Endpoints.login,
                method: .POST,
                body: body,
                responseType: UserResponseDTO.self
            )
            
            print("Login API successful, user: \(userResponse.name ?? "Unknown")")
            
            return userResponse.toAuthResponse()
            
        } catch let apiError as APIError {
            print("API login error: \(apiError)")
            throw apiError
        } catch {
            print("Failed to encode login data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Get user by ID
    func getUser(id: UUID) async throws -> UserResponseDTO {
        print("Fetching user with ID: \(id.uuidString)")
        
        return try await performRequest(
            endpoint: Endpoints.user(id: id),
            method: .GET,
            responseType: UserResponseDTO.self
        )
    }
    
    /// Update user
    func updateUser(id: UUID, data: UserUpdateDTO) async throws -> UserResponseDTO {
        print("Updating user with ID: \(id.uuidString)")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            return try await performRequest(
                endpoint: Endpoints.user(id: id),
                method: .PUT,
                body: body,
                responseType: UserResponseDTO.self
            )
        } catch let apiError as APIError {
            print("API update error: \(apiError)")
            throw apiError
        } catch {
            print("Failed to encode user update data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Get all users (admin function)
    func getAllUsers() async throws -> [UserResponseDTO] {
        print("Fetching all users...")
        
        return try await performRequest(
            endpoint: Endpoints.users,
            method: .GET,
            responseType: [UserResponseDTO].self
        )
    }
}
