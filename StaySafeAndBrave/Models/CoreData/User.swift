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
    var role: UserRole
    var created_at: Date
    var birth_date: Date
    
    init(
        user_id: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        role: UserRole,
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

enum UserRole: String, Codable {
    case user
    case mentor
}
