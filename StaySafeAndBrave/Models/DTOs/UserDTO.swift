//
//  UserDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

// MARK: - User Response DTO

struct UserResponseDTO: Codable {
    var id: UUID?
    var name: String?
    var email: String?
    var role: String?
    var birth_date: String?
    var created_at: String?
    var updated_at: String?
    
    // MARK: - Computed Properties
    
    /// Convert birth_date string to Date
    var birthDateAsDate: Date? {
        guard let birth_date = birth_date else { return nil }
        return birth_date.apiDate
    }
    
    /// Convert role string to Role enum
    var roleEnum: Role? {
        guard let role = role else { return nil }
        return Role(rawValue: role)
    }
}

// MARK: - Registration Response

typealias RegistrationResponseDTO = UserResponseDTO

// MARK: - Auth Response DTO

/// Response DTO for authentication (login)
struct AuthResponseDTO: Codable {
    var user: UserResponseDTO?
    var token: String?
    var message: String?
    
    var isSuccess: Bool {
        return user != nil
    }
    
    // For direct user response (like registration)
    init(from userResponse: UserResponseDTO) {
        self.user = userResponse
        self.token = nil
        self.message = nil
    }
}

// MARK: - User Registration DTO

/// DTO for registering new users
struct UserRegistrationDTO: Codable {
    var name: String
    var email: String
    var password: String
    var role: String
    var birth_date: String?
    
    // MARK: - Initializers
    
    init(name: String, email: String, password: String, role: Role, birth_date: Date? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.role = role.rawValue
        self.birth_date = birth_date?.apiString
    }
    
    /// Direct initializer with backend-compatible types
    init(name: String, email: String, password: String, role: String, birth_date: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
    }
}

// MARK: - User Login DTO

/// DTO for user login
struct UserLoginDTO: Codable {
    var email: String
    var password: String
}

// MARK: - User Update DTO

/// DTO for updating user information
struct UserUpdateDTO: Codable {
    var name: String?
    var email: String?
    var birth_date: String?
    
    // MARK: - Initializers
    
    /// Main initializer that accepts frontend types
    init(name: String? = nil, email: String? = nil, birth_date: Date? = nil) {
        self.name = name
        self.email = email
        self.birth_date = birth_date?.apiString
    }
}

// MARK: - Conversion Extensions

extension UserResponseDTO {
    /// Convert backend response to frontend Profile
    func toProfile() -> Profile {
        return Profile(
            user_id: self.id?.uuidString ?? UUID().uuidString,
            name: self.name,
            email: self.email,
            role: self.roleEnum ?? .user,
            birth_date: self.birthDateAsDate
        )
    }
    
    /// Convert to AuthResponseDTO for compatibility
    func toAuthResponse() -> AuthResponseDTO {
        return AuthResponseDTO(from: self)
    }
}

extension Profile {
    /// Convert frontend Profile to backend registration DTO
    func toRegistrationDTO(password: String) -> UserRegistrationDTO {
        return UserRegistrationDTO(
            name: self.name ?? "",
            email: self.email ?? "",
            password: password,
            role: self.role ?? .user,
            birth_date: self.birth_date
        )
    }
    
    /// Convert frontend Profile to backend update DTO
    func toUpdateDTO() -> UserUpdateDTO {
        return UserUpdateDTO(
            name: self.name,
            email: self.email,
            birth_date: self.birth_date
        )
    }
}
