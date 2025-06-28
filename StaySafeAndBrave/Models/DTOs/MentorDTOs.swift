//
//  MentorDTOs.swift
//  StaySafeAndBrave
//
//  Purpose: Data Transfer Objects for API communication with backend
//  Uses existing enums: AvailableLanguage, Hobby, City
//

import Foundation

// MARK: - Response DTO

/// Response DTO that matches your backend MentorResponseDTO
/// This is what the backend sends to the frontend
struct MentorResponseDTO: Codable {
    var id: UUID?
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String? // Backend sends this as String
    var bio: String?
    var languages: [String]? // Backend uses [String], we convert to [AvailableLanguage]
    var hobbies: [String]? // Backend uses [String], we convert to [Hobby]
    var location: String? // Backend uses String, we convert to City
    
    // MARK: - Computed Properties
    
    /// Convert birth_date string to Date using centralized formatter
    var birthDateAsDate: Date? {
        guard let birth_date = birth_date else { return nil }
        return birth_date.apiDate
    }
    
    /// Get display-friendly birth date
    var birthDateDisplay: String? {
        guard let birthDate = birthDateAsDate else { return nil }
        return birthDate.displayString
    }
    
    /// Convert backend language strings to frontend AvailableLanguage enums
    var frontendLanguages: [AvailableLanguage]? {
        guard let languages = languages else { return nil }
        return languages.compactMap { AvailableLanguage(rawValue: $0) }
    }
    
    /// Convert backend hobby strings to frontend Hobby enums
    var frontendHobbies: [Hobby]? {
        guard let hobbies = hobbies else { return nil }
        return hobbies.compactMap { Hobby(rawValue: $0) }
    }
    
    /// Convert backend location string to frontend City enum
    var frontendLocation: City? {
        guard let location = location else { return nil }
        return City(rawValue: location)
    }
}

// MARK: - Create DTO

/// Create DTO for creating new mentors
/// This is what the frontend sends to the backend when creating a mentor
struct MentorCreateDTO: Codable {
    var userID: UUID // Backend requires userID
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String? // Send as string to match backend expectations
    var bio: String?
    var languages: [String]? // Send as strings to backend
    var hobbies: [String]? // Send as strings to backend
    var location: String? // Send as string to backend
    
    // MARK: - Initializers
    
    /// Main initializer that accepts your frontend types and converts them to backend format
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
        
        // Convert Date to String using centralized formatter
        self.birth_date = birth_date?.apiString
    }
    
    /// Alternative initializer if you already have backend-compatible types
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

/// Update DTO for updating existing mentors
/// This is what the frontend sends to the backend when updating a mentor
struct MentorUpdateDTO: Codable {
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String? // Send as string to match backend expectations
    var bio: String?
    var languages: [String]? // Send as strings to backend
    var hobbies: [String]? // Send as strings to backend
    var location: String? // Send as string to backend
    
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
    
    /// Alternative initializer if you already have backend-compatible types
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
    /// Convert backend response to your frontend Mentor model
    func toMentorModel() -> Mentor {
        return Mentor(
            timestamp_creation: Date(), // Use current date since backend doesn't provide this
            id: self.id ?? UUID(),
            name: self.name ?? "Unknown",
            profile_image: self.profile_image,
            score: self.score,
            birth_date: self.birthDateAsDate ?? Date(),
            bio: self.bio,
            languages: self.frontendLanguages, // Uses computed property
            hobbies: self.frontendHobbies, // Uses computed property
            location: self.frontendLocation ?? .capetown // Uses computed property with fallback
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
    /// Validate that the DTO has required fields for backend
    var isValid: Bool {
        // Add validation logic based on your backend requirements
        return !userID.uuidString.isEmpty
    }
    
    /// Get validation errors
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
    /// Check if the update DTO has any fields to update
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
