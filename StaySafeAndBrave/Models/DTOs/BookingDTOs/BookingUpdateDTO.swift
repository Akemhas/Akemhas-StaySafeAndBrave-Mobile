//
//  BookingUpdateDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - Update DTO
struct BookingUpdateDTO: Codable {
    var mentorID: UUID?
    var date: Date?
    var status: String?
    var description: String?
    
    // MARK: - Initializers
    init(mentorID: UUID? = nil,
         date: Date? = nil,
         status: String? = nil,
         description: String? = nil) {
        
        self.mentorID = mentorID
        self.date = date
        self.status = status
        self.description = description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mentorID, forKey: .mentorID)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(description, forKey: .description)
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: date)
            try container.encode(dateString, forKey: .date)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case mentorID = "mentorID"
        case date
        case status
        case description
    }
}

// MARK: - Validation Extensions
extension BookingUpdateDTO {
    var hasUpdates: Bool {
        return mentorID != nil || date != nil || status != nil || description != nil
    }
}
