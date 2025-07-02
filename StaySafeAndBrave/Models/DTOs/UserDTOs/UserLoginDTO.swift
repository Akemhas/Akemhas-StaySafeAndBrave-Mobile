//
//  UserLoginDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - User Login DTO
struct UserLoginDTO: Codable {
    var email: String
    var password: String
    
    // MARK: - Initializers
    
    init(email: String, password: String) {
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.password = password
    }
}

// MARK: - Validation Extensions

extension UserLoginDTO {
    var isValid: Bool {
        return !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Email is required")
        } else if !email.contains("@") {
            errors.append("Please enter a valid email address")
        }
        
        if password.isEmpty {
            errors.append("Password is required")
        }
        
        return errors
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Sanitized version for logging (without password)
    var sanitizedDescription: String {
        return "UserLoginDTO(email: \(email), password: [HIDDEN])"
    }
}
