//
//  User.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var user_id: UUID
    var name: String
    var email: String
    var password: String
    var role: Role
    var created_at: Date
    var birth_date: Date
    
    init(
        user_id: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        role: Role,
        created_at: Date = Date(),
        birth_date: Date,
    ) {
        self.user_id = user_id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.created_at = created_at
        self.birth_date = birth_date
    }
}

// MARK: - API Conversion Extensions (FROM User TO other types)
extension User {
    /// Convert SwiftData model to registration DTO
    func toRegistrationDTO(password: String) -> UserRegistrationDTO {
        return UserRegistrationDTO(
            name: self.name,
            email: self.email,
            password: password,
            role: self.role,
            birth_date: self.birth_date
        )
    }
    
    /// Convert SwiftData model to update DTO
    func toUpdateDTO() -> UserUpdateDTO {
        return UserUpdateDTO(
            name: self.name,
            email: self.email,
            birth_date: self.birth_date
        )
    }
}
