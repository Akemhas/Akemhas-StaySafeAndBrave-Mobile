//
//  BookingResponseDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

import Foundation

// MARK: - Main Booking Response DTO
struct BookingResponseDTO: Codable, Identifiable {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var userName: String?
    var mentorName: String?
    var mentorLocation: String?
    var mentorImage: String?
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
    
    /// Check if booking is cancelled
    var isCancelled: Bool {
        return status?.lowercased() == "cancelled"
    }
    
    /// Get display name based on context
    var displayName: String {
        return mentorName ?? userName ?? "Unknown"
    }
    
    /// Get display location
    var displayLocation: String {
        return mentorLocation ?? "Unknown Location"
    }
    
    /// Get display image
    var displayImage: String {
        return mentorImage ?? ""
    }
}
