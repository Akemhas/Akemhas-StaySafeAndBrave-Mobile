//
//  ProfilePersistence.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/1/25.
//

import Foundation

extension Profile {
    private static let userDefaultsKey = "SavedUserProfile"
    
    // MARK: - Save Profile
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
            print("Profile saved successfully")
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    // MARK: - Load Profile
    static func load() -> Profile {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            print("No saved profile found")
            return .empty
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let profile = try decoder.decode(Profile.self, from: data)
            print("Profile loaded successfully: \(profile.name ?? "Unknown")")
            return profile
        } catch {
            print("Failed to load profile: \(error)")
            // Clear corrupted data
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            return .empty
        }
    }
    
    // MARK: - Clear Profile
    static func clearSaved() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        print("Saved profile cleared")
    }
    
    // MARK: - Check if logged in
    var isLoggedIn: Bool {
        return self != .empty && user_id != "null" && !(name?.isEmpty ?? true)
    }
}

// MARK: - Make Profile Codable
extension Profile: Codable {
    enum CodingKeys: String, CodingKey {
        case user_id, name, email, role, birth_date, hobbies, languages, image, city, bio, rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user_id = try container.decode(String.self, forKey: .user_id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        role = try container.decodeIfPresent(Role.self, forKey: .role)
        birth_date = try container.decodeIfPresent(Date.self, forKey: .birth_date)
        hobbies = try container.decodeIfPresent([Hobby].self, forKey: .hobbies)
        languages = try container.decodeIfPresent([AvailableLanguage].self, forKey: .languages)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        city = try container.decodeIfPresent(City.self, forKey: .city)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(user_id, forKey: .user_id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(birth_date, forKey: .birth_date)
        try container.encodeIfPresent(hobbies, forKey: .hobbies)
        try container.encodeIfPresent(languages, forKey: .languages)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(rating, forKey: .rating)
    }
}
