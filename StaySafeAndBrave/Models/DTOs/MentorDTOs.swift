//
//  UserDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

// MARK: - Response DTO

struct MentorResponseDTO: Codable {
    var id: UUID?
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String? // Backend sends this as String
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
}

// MARK: - Create DTO

struct MentorCreateDTO: Codable {
    var userID: UUID
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String?
    var bio: String?
    var languages: [String]?
    var hobbies: [String]?
    var location: String?
    
    // MARK: - Initializers
    
    init(userID: UUID,
         name: String? = nil,
         profile_image: String? = nil,
         score: Float? = nil,
         birth_date: Date? = nil,
         bio: String? = nil,
         languages: [AvailableLanguage]? = nil,
         hobbies: [Hobby]? = nil,
         location: City? = nil) {
        
        self.userID = userID
        self.name = name
        self.profile_image = profile_image
        self.score = score
        self.bio = bio
        
        // Convert frontend types to backend strings
        self.languages = languages?.map { $0.rawValue }
        self.hobbies = hobbies?.map { $0.rawValue }
        self.location = location?.rawValue
        
        // Convert Date to String
        self.birth_date = birth_date?.apiString
    }
    
    init(userID: UUID,
         name: String? = nil,
         profile_image: String? = nil,
         score: Float? = nil,
         birth_date: String? = nil,
         bio: String? = nil,
         languages: [String]? = nil,
         hobbies: [String]? = nil,
         location: String? = nil) {
        
        self.userID = userID
        self.name = name
        self.profile_image = profile_image
        self.score = score
        self.birth_date = birth_date
        self.bio = bio
        self.languages = languages
        self.hobbies = hobbies
        self.location = location
    }
}

// MARK: - Update DTO

struct MentorUpdateDTO: Codable {
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String?
    var bio: String?
    var languages: [String]?
    var hobbies: [String]?
    var location: String?
    
    // MARK: - Initializers
    
    /// Main initializer that accepts your frontend types and converts them to backend format
    init(name: String? = nil,
         profile_image: String? = nil,
         score: Float? = nil,
         birth_date: Date? = nil,
         bio: String? = nil,
         languages: [AvailableLanguage]? = nil,
         hobbies: [Hobby]? = nil,
         location: City? = nil) {
        
        self.name = name
        self.profile_image = profile_image
        self.score = score
        self.bio = bio
        
        // Convert frontend types to backend strings
        self.languages = languages?.map { $0.rawValue }
        self.hobbies = hobbies?.map { $0.rawValue }
        self.location = location?.rawValue
        
        // Convert Date to String using centralized formatter
        self.birth_date = birth_date?.apiString
    }
    
    init(name: String? = nil,
         profile_image: String? = nil,
         score: Float? = nil,
         birth_date: String? = nil,
         bio: String? = nil,
         languages: [String]? = nil,
         hobbies: [String]? = nil,
         location: String? = nil) {
        
        self.name = name
        self.profile_image = profile_image
        self.score = score
        self.birth_date = birth_date
        self.bio = bio
        self.languages = languages
        self.hobbies = hobbies
        self.location = location
    }
}

// MARK: - Conversion Extensions

extension MentorResponseDTO {
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
}

extension Mentor {
    /// Convert your frontend Mentor model to backend create DTO
    func toCreateDTO(userID: UUID) -> MentorCreateDTO {
        return MentorCreateDTO(
            userID: userID,
            name: self.name,
            profile_image: self.profile_image.isEmpty ? nil : self.profile_image,
            score: self.score,
            birth_date: self.birth_date,
            bio: self.bio.isEmpty ? nil : self.bio,
            languages: self.languages,
            hobbies: self.hobbies,
            location: self.location
        )
    }
    
    /// Convert your frontend Mentor model to backend update DTO
    func toUpdateDTO() -> MentorUpdateDTO {
        return MentorUpdateDTO(
            name: self.name,
            profile_image: self.profile_image.isEmpty ? nil : self.profile_image,
            score: self.score,
            birth_date: self.birth_date,
            bio: self.bio.isEmpty ? nil : self.bio,
            languages: self.languages,
            hobbies: self.hobbies,
            location: self.location
        )
    }
}

// MARK: - Validation Extensions

extension MentorCreateDTO {
    var isValid: Bool {
        return !userID.uuidString.isEmpty
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if userID.uuidString.isEmpty {
            errors.append("User ID is required")
        }
        
        if let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name cannot be empty")
        }
        
        return errors
    }
}

extension MentorUpdateDTO {
    var hasUpdates: Bool {
        return name != nil ||
               profile_image != nil ||
               score != nil ||
               birth_date != nil ||
               bio != nil ||
               languages != nil ||
               hobbies != nil ||
               location != nil
    }
}
