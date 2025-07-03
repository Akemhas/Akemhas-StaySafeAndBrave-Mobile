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
