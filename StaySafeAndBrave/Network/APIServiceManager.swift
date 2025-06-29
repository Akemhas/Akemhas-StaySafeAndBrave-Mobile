//
//  APIServiceManager.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import Foundation

/// Centralized access point for all API services
/// This provides a single entry point to access different API services
class APIServiceManager {
    static let shared = APIServiceManager()
    
    // MARK: - Available Services
    
    let mentors = MentorAPIService.shared
    let users = UserAPIService.shared
    let bookings = BookingAPIService.shared
    // let auth = AuthAPIService.shared
    
    private init() {}
    
    // MARK: - Convenience Methods
    
    /// Check if the API server is reachable
    func checkServerHealth() async -> Bool {
        do {
            // Try to fetch mentors as a health check
            let _ = try await mentors.fetchMentors()
            return true
        } catch {
            print("❌ Server health check failed: \(error)")
            return false
        }
    }
    
    /// Get the base URL being used by all services
    var baseURL: String {
        return mentors.baseURL.absoluteString
    }
}

// MARK: - Usage Examples

/*
// In your ViewModels, you can use it like this:

class BookingViewModel: ObservableObject {
    private let apiManager = APIServiceManager.shared
    
    func fetchUserBookings(userID: UUID) async {
        do {
            let bookings = try await apiManager.bookings.fetchUserBookings(userID: userID)
            // Handle success
        } catch {
            // Handle error
        }
    }
}

// Or access services directly:
let bookingService = APIServiceManager.shared.bookings
let bookings = try await bookingService.fetchUserBookings(userID: userID)

// Check server connectivity:
let isServerUp = await APIServiceManager.shared.checkServerHealth()
if !isServerUp {
    // Show offline message to user
}
*/
