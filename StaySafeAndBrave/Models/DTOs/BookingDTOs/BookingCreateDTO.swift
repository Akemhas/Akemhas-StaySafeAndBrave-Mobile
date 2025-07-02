//
//  BookingCreateDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - Create DTO
struct BookingCreateDTO: Codable {
    var userID: UUID
    var mentorID: UUID
    var date: Date
    var status: String?
    var description: String?
    
    // MARK: - Initializers
    init(userID: UUID,
         mentorID: UUID,
         date: Date,
         status: String? = "pending",
         description: String? = nil) {
        
        self.userID = userID
        self.mentorID = mentorID
        self.date = date
        self.status = status ?? "pending"
        self.description = description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(mentorID, forKey: .mentorID)
        try container.encode(status, forKey: .status)
        try container.encode(description, forKey: .description)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "userID"
        case mentorID = "mentorID"
        case date
        case status
        case description
    }
}

// MARK: - Validation Extensions
extension BookingCreateDTO {
    var isValid: Bool {
        return !userID.uuidString.isEmpty && !mentorID.uuidString.isEmpty
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if userID.uuidString.isEmpty {
            errors.append("User ID is required")
        }
        
        if mentorID.uuidString.isEmpty {
            errors.append("Mentor ID is required")
        }
        
        return errors
    }
}
