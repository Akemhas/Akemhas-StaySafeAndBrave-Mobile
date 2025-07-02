//
//  UserResponseDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - Main User Response DTO
struct UserResponseDTO: Codable, Identifiable {
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
    
    var displayName: String {
        return name ?? "Unknown User"
    }
    
    var displayEmail: String {
        return email ?? "No email"
    }
    
    var displayRole: String {
        return role?.capitalized ?? "User"
    }
    
    var displayLocation: String {
        return location ?? "Unknown Location"
    }
    
    var displayBio: String {
        return bio ?? "No bio available"
    }
    
    var displayScore: String {
        guard let score = score else { return "0.0" }
        return String(format: "%.1f", score)
    }
}

// MARK: - Auth Response DTO
struct AuthResponseDTO: Codable {
    var user: UserResponseDTO?
    var token: String?
    var message: String?
    
    var isSuccess: Bool {
        return user != nil
    }
    
    init(from userResponse: UserResponseDTO) {
        self.user = userResponse
        self.token = nil
        self.message = nil
    }
}

// MARK: - Combined User + Mentor Response DTO
struct UserMentorDTO: Codable {
    var id: UUID?
    var mentorID: UUID?
    var name: String?
    var email: String?
    var password: String?
    var role: String?
    var birth_date: String?
    var location: String?
    var bio: String?
    var profile_image: String?
    var score: Float?
    var languages: [String]?
    var hobbies: [String]?

    init(
        id: UUID? = nil,
        mentorID: UUID? = nil,
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        role: String? = nil,
        birth_date: String? = nil,
        location: String? = nil,
        bio: String? = nil,
        profile_image: String? = nil,
        score: Float? = nil,
        languages: [String]? = nil,
        hobbies: [String]? = nil
    ) {
        self.id = id
        self.mentorID = mentorID
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
        self.location = location
        self.bio = bio
        self.profile_image = profile_image
        self.score = score
        self.languages = languages
        self.hobbies = hobbies
    }
}

// MARK: - Conversion Extensions (FROM UserResponseDTO TO other types)

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
            rating: self.score ?? 0.0
        )
    }
    
    /// Convert to AuthResponseDTO for compatibility
    func toAuthResponse() -> AuthResponseDTO {
        return AuthResponseDTO(from: self)
    }
}

// MARK: - Type Aliases for Compatibility
typealias RegistrationResponseDTO = UserResponseDTO
