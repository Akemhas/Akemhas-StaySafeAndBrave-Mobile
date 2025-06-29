//
//  BookingDTOs.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation

// MARK: - Response DTO

/// Response DTO that matches your backend BookingDTO
/// This is what the backend sends to the frontend
struct BookingResponseDTO: Codable {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var date: Date?
    var status: String?
    var description: String?
    
    // MARK: - Computed Properties
    
    /// Convert date to display string
    var dateDisplay: String? {
        guard let date = date else { return nil }
        return date.displayString
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
/// This is what the frontend sends to the backend when creating a booking
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
    
    // Custom encoding to match backend date format expectations
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(mentorID, forKey: .mentorID)
        try container.encode(status, forKey: .status)
        try container.encode(description, forKey: .description)
        
        // Encode date in the format the backend expects
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user"
        case mentorID = "mentor"
        case date
        case status
        case description
    }
}

// MARK: - Update DTO

/// Update DTO for updating existing bookings
/// This is what the frontend sends to the backend when updating a booking
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
    
    // Custom encoding to match backend date format expectations
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mentorID, forKey: .mentorID)
        try container.encodeIfPresent(status, forKey: .status)
        
        // Encode date in the format the backend expects if provided
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: date)
            try container.encode(dateString, forKey: .date)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case mentorID = "mentor"
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
            date: self.date ?? Date(),
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
    /// Check if the update DTO has any fields to update
    var hasUpdates: Bool {
        return mentorID != nil || date != nil || status != nil
    }
}
