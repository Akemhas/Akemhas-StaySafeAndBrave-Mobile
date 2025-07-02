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
    var profile_image: String // Path to the image. Right now only working with links
    var score: Float
    var birth_date: Date
    var bio: String
    var languages: [AvailableLanguage]?
    var hobbies: [Hobby]?
    var location: City
    var location_for_sorting: String? // needed to make sorting work
    // age calculated for display purposes only. Sort with birth_date
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birth_date, to: Date())
        return ageComponents.year ?? 0
    }
    
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
