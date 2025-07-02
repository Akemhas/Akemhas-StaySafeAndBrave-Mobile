//
//  UserRegistrationDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - User Registration DTO
struct UserRegistrationDTO: Codable {
    var name: String
    var email: String
    var password: String
    var role: String
    var birth_date: String?
    
    // MARK: - Initializers
    
    /// Main initializer that accepts frontend types and converts them to backend format
    init(name: String, email: String, password: String, role: Role, birth_date: Date? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.role = role.rawValue
        self.birth_date = birth_date?.apiString
    }
    
    /// Direct initializer with backend-compatible types
    init(name: String, email: String, password: String, role: String, birth_date: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
    }
}

// MARK: - Validation Extensions

extension UserRegistrationDTO {
    var isValid: Bool {
        let basicFieldsValid = ![name, email, password].contains(where: \.isEmpty)
        let emailValid = email.contains("@")
        let passwordValid = password.count >= 6
        
        return basicFieldsValid && emailValid && passwordValid
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Name is required")
        }
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Email is required")
        } else if !email.contains("@") {
            errors.append("Please enter a valid email address")
        }
        
        if password.isEmpty {
            errors.append("Password is required")
        } else if password.count < 6 {
            errors.append("Password must be at least 6 characters")
        }
        
        if !Role.allCases.map(\.rawValue).contains(role) {
            errors.append("Invalid role selected")
        }
        
        return errors
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordStrong: Bool {
        return password.count >= 8 &&
               password.rangeOfCharacter(from: .decimalDigits) != nil &&
               password.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
}
