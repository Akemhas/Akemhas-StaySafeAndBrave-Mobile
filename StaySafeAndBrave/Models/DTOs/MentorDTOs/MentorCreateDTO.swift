//
//  MentorCreateDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

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
    
    /// Main initializer that accepts frontend types and converts them to backend format
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
    
    /// Direct initializer with backend-compatible types
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
        
        if let score = score, score < 0 || score > 5 {
            errors.append("Score must be between 0 and 5")
        }
        
        return errors
    }
}
