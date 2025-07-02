//
//  Mentor.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 14.05.25.
//

import Foundation
import SwiftData

@Model
final class Mentor {
    var timestamp_creation: Date
    var timestamp_last_update: Date
    @Attribute(.unique) var id: UUID
    var name: String
    var profile_image: String
    var score: Float
    var birth_date: Date
    var bio: String
    var languages: [AvailableLanguage]?
    var hobbies: [Hobby]?
    var location: City
    var location_for_sorting: String?
    
    // MARK: - Computed Properties
    
    /// Age calculated for display purposes only. Sort with birth_date
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birth_date, to: Date())
        return ageComponents.year ?? 0
    }
    
    var displayName: String {
        return name.isEmpty ? "Unknown Mentor" : name
    }
    
    var displayLocation: String {
        return location.description
    }
    
    var displayImage: String {
        return profile_image.isEmpty ? "" : profile_image
    }
    
    var displayScore: String {
        return String(format: "%.1f", score)
    }
    
    var displayBio: String {
        return bio.isEmpty ? "No bio available" : bio
    }
    
    var displayLanguages: [AvailableLanguage] {
        return languages ?? []
    }
    
    var displayHobbies: [Hobby] {
        return hobbies ?? []
    }
    
    // MARK: - Initializers
    
    init(timestamp_creation: Date? = nil,
         id: UUID = UUID(),
         name: String,
         profile_image: String? = nil,
         score: Float? = nil,
         birth_date: Date,
         bio: String? = nil,
         languages: [AvailableLanguage]? = [AvailableLanguage.english],
         hobbies: [Hobby]? = nil,
         location: City? = City.capetown) {
        
        self.timestamp_creation = timestamp_creation ?? Date()
        self.timestamp_last_update = Date()
        self.id = id
        self.name = name
        self.profile_image = profile_image ?? ""
        self.score = score ?? 0.0
        self.birth_date = birth_date
        self.bio = bio ?? "This field has not been filled yet."
        self.languages = languages
        self.hobbies = hobbies
        self.location = location!
        self.location_for_sorting = location?.rawValue ?? "Location not specified"
    }
}

// MARK: - API Conversion Extensions (FROM Mentor TO other types)

extension Mentor {
    /// Convert SwiftData model to API create DTO
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
    
    /// Convert SwiftData model to API update DTO
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
