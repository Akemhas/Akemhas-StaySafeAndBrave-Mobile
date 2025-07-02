//
//  MentorResponseDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - Main Mentor Response DTO
struct MentorResponseDTO: Codable, Identifiable {
    var id: UUID?
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String?
    var bio: String?
    var languages: [String]?
    var hobbies: [String]?
    var location: String?
    
    // MARK: - Computed Properties
    
    var birthDateAsDate: Date? {
        guard let birth_date = birth_date else { return nil }
        return birth_date.apiDate
    }
    
    var birthDateDisplay: String? {
        guard let birthDate = birthDateAsDate else { return nil }
        return birthDate.displayString
    }
    
    var frontendLanguages: [AvailableLanguage]? {
        guard let languages = languages else { return nil }
        return languages.compactMap { AvailableLanguage(rawValue: $0) }
    }
    
    var frontendHobbies: [Hobby]? {
        guard let hobbies = hobbies else { return nil }
        return hobbies.compactMap { Hobby(rawValue: $0) }
    }
    
    var frontendLocation: City? {
        guard let location = location else { return nil }
        return City(rawValue: location)
    }
    
    var displayName: String {
        return name ?? "Unknown Mentor"
    }
    
    var displayLocation: String {
        return location ?? "Unknown Location"
    }
    
    var displayImage: String {
        return profile_image ?? ""
    }
    
    var displayScore: String {
        guard let score = score else { return "0.0" }
        return String(format: "%.1f", score)
    }
    
    var displayBio: String {
        return bio ?? "No bio available"
    }
}

// MARK: - Auth Response DTO
struct MentorAuthResponseDTO: Codable {
    var user: MentorResponseDTO?
    var token: String?
    var message: String?
    
    var isSuccess: Bool {
        return user != nil
    }
    
    init(from userResponse: MentorResponseDTO) {
        self.user = userResponse
        self.token = nil
        self.message = nil
    }
}

// MARK: - Conversion Extensions (FROM MentorResponseDTO TO other types)

extension MentorResponseDTO {
    /// Convert API response to SwiftData model
    func toMentorModel() -> Mentor {
        return Mentor(
            timestamp_creation: Date(),
            id: self.id ?? UUID(),
            name: self.name ?? "Unknown",
            profile_image: self.profile_image,
            score: self.score,
            birth_date: self.birthDateAsDate ?? Date(),
            bio: self.bio,
            languages: self.frontendLanguages,
            hobbies: self.frontendHobbies,
            location: self.frontendLocation ?? .capetown
        )
    }
    
    /// Convert to auth response wrapper
    func toMentorAuthResponse() -> MentorAuthResponseDTO {
        return MentorAuthResponseDTO(from: self)
    }
}
