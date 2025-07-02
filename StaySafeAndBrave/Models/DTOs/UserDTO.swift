//
//  UserDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

// MARK: - User Response DTO

struct UserResponseDTO: Codable {
    var id: UUID?
    var mentorID: UUID?
    var name: String?
    var email: String?
    var role: String?
    var birth_date: String?
    var created_at: String?
    var updated_at: String?
    var profile_image: String?
    var score: Float?
    var bio: String?
    var location: String?
    var languages: [String]?
    var hobbies: [String]?
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
    
    var cityEnum: City? {
        guard let location = location else { return nil }
        return City(rawValue: location)
    }
    
    var languageEnums: [AvailableLanguage] {
        guard let languages = languages else { return [] }
        return languages.compactMap(AvailableLanguage.init(rawValue:))
    }
    
    var hobbyEnums: [Hobby] {
        guard let hobbies = hobbies else { return [] }
        return hobbies.compactMap(Hobby.init(rawValue:))
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
            mentor_id: self.mentorID?.uuidString,
            name: self.name,
            email: self.email,
            role: self.roleEnum ?? .user,
            birth_date: self.birthDateAsDate,
            hobbies: self.hobbyEnums,
            languages: self.languageEnums,
            image: self.profile_image ?? "",
            city: self.cityEnum ?? .dortmund,
            bio: self.bio ?? "",
            rating: self.score ?? 0.0,
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
