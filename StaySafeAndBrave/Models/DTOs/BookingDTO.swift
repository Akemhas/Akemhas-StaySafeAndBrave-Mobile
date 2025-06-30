//
//  BookingDTOs.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

// MARK: - Response DTO

struct BookingResponseDTO: Codable {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var date: String?
    var status: String?
    var description: String?
    
    // MARK: - Computed Properties
    
    /// Convert string date to Date object
    var dateAsDate: Date? {
        guard let dateString = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: dateString)
    }
    
    /// Convert date to display string
    var dateDisplay: String? {
        guard let dateObj = dateAsDate else { return date }
        return dateObj.displayString
    }
    
    /// Get status display with proper capitalization
    var statusDisplay: String {
        return status?.capitalized ?? "Unknown"
    }
    
    /// Check if booking is pending
    var isPending: Bool {
        return status?.lowercased() == "pending"
    }
    
    /// Check if booking is accepted
    var isAccepted: Bool {
        return status?.lowercased() == "accepted"
    }
    
    /// Check if booking is rejected
    var isRejected: Bool {
        return status?.lowercased() == "rejected"
    }
}

// MARK: - Create DTO

/// Create DTO for creating new bookings
struct BookingCreateDTO: Codable {
    var userID: UUID
    var mentorID: UUID
    var date: Date
    var status: String?
    var description: String?
    
    // MARK: - Initializers
    
    /// Main initializer for creating bookings
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

// MARK: - Update DTO

/// Update DTO for updating existing bookings
struct BookingUpdateDTO: Codable {
    var mentorID: UUID?
    var date: Date?
    var status: String?
    
    // MARK: - Initializers
    
    init(mentorID: UUID? = nil,
         date: Date? = nil,
         status: String? = nil) {
        
        self.mentorID = mentorID
        self.date = date
        self.status = status
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mentorID, forKey: .mentorID)
        try container.encodeIfPresent(status, forKey: .status)
        
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
    }
}

// MARK: - Conversion Extensions

extension BookingResponseDTO {
    /// Convert backend response to your frontend Booking model
    func toBookingModel(user: User, mentor: User, package: Package) -> Booking {
        return Booking(
            booking_id: self.id ?? UUID(),
            date: self.dateAsDate ?? Date(),
            status: self.status ?? "pending",
            user: user,
            mentor: mentor,
            package: package
        )
    }
}

extension Booking {
    /// Convert your frontend Booking model to backend create DTO
    func toCreateDTO() -> BookingCreateDTO {
        return BookingCreateDTO(
            userID: self.user.user_id,
            mentorID: self.mentor.user_id,
            date: self.date,
            status: self.status,
            description: "" // Add description field to your Booking model if needed
        )
    }
    
    /// Convert your frontend Booking model to backend update DTO
    func toUpdateDTO() -> BookingUpdateDTO {
        return BookingUpdateDTO(
            mentorID: self.mentor.user_id,
            date: self.date,
            status: self.status
        )
    }
}

// MARK: - Validation Extensions

extension BookingCreateDTO {
    /// Validate that the DTO has required fields for backend
    var isValid: Bool {
        return !userID.uuidString.isEmpty && !mentorID.uuidString.isEmpty
    }
    
    /// Get validation errors
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

extension BookingUpdateDTO {
    var hasUpdates: Bool {
        return mentorID != nil || date != nil || status != nil
    }
}
