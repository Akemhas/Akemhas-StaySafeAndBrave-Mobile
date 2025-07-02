//
//  UserUpdateDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - User Update DTO
struct UserUpdateDTO: Codable {
    var name: String?
    var email: String?
    var birth_date: String?
    
    // MARK: - Initializers
    
    /// Main initializer that accepts frontend types
    init(name: String? = nil, email: String? = nil, birth_date: Date? = nil) {
        self.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.birth_date = birth_date?.apiString
    }
    
    /// Direct initializer with backend-compatible types
    init(name: String? = nil, email: String? = nil, birth_date: String? = nil) {
        self.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.birth_date = birth_date
    }
}

// MARK: - Validation Extensions

extension UserUpdateDTO {
    var hasUpdates: Bool {
        return name != nil || email != nil || birth_date != nil
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name cannot be empty")
        }
        
        if let email = email, !email.isEmpty {
            if !email.contains("@") {
                errors.append("Please enter a valid email address")
            } else if !isEmailValid {
                errors.append("Email format is invalid")
            }
        }
        
        if let birthDate = birth_date, let date = birthDate.apiDate {
            let ageComponents = Calendar.current.dateComponents([.year], from: date, to: Date())
            if let age = ageComponents.year, age < 13 {
                errors.append("Must be at least 13 years old")
            }
        }
        
        return errors
    }
    
    var isEmailValid: Bool {
        guard let email = email, !email.isEmpty else { return true } // nil/empty is okay for updates
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isValid: Bool {
        return hasUpdates && validationErrors.isEmpty
    }
    
    /// Returns only the fields that have actual updates (non-nil and non-empty)
    var nonEmptyUpdates: UserUpdateDTO {
        return UserUpdateDTO(
            name: (name?.isEmpty == false) ? name : nil,
            email: (email?.isEmpty == false) ? email : nil,
            birth_date: birth_date
        )
    }
}
