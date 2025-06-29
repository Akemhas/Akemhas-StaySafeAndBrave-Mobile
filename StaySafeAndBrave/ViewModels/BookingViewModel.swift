//
//  BookingViewModel.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import SwiftUI
import SwiftData

@MainActor
final class BookingViewModel: ObservableObject {
    var modelContext: ModelContext?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var bookings: [BookingResponseDTO] = []
    
    // Use the BookingAPIService
    private let bookingAPIService = BookingAPIService.shared
    
    func onAppear(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Fetch user bookings
    func fetchUserBookings(userID: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            print("Starting to fetch bookings for user: \(userID)")
            
            let fetchedBookings = try await bookingAPIService.fetchUserBookings(userID: userID)
            
            print("Successfully fetched \(fetchedBookings.count) bookings from API")
            
            bookings = fetchedBookings
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error fetching bookings: \(error.localizedDescription)"
            print("Error fetching bookings: \(error)")
            
            // If it's an API error, show more detailed info
            if let apiError = error as? APIError {
                print("API Error details: \(apiError.errorDescription ?? "Unknown")")
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Create booking
    func createBooking(userID: UUID, mentorID: UUID, date: Date, description: String? = nil) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        let createDTO = BookingCreateDTO(
            userID: userID,
            mentorID: mentorID,
            date: date,
            status: "pending",
            description: description
        )
        
        do {
            print("Creating booking for mentor: \(mentorID)")
            
            let createdBooking = try await bookingAPIService.createBooking(data: createDTO)
            
            bookings.append(createdBooking)
            
            print("Successfully created booking: \(createdBooking.id?.uuidString ?? "unknown")")
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = "Error creating booking: \(error.localizedDescription)"
            print("Error creating booking: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
            return false
        }
    }
    
    // MARK: - Update booking
    func updateBooking(id: UUID, mentorID: UUID? = nil, date: Date? = nil, status: String? = nil) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        let updateDTO = BookingUpdateDTO(
            mentorID: mentorID,
            date: date,
            status: status
        )
        
        do {
            print("Updating booking: \(id)")
            
            let updatedBooking = try await bookingAPIService.updateBooking(id: id, data: updateDTO)
            
            // Update the booking in our local list
            if let index = bookings.firstIndex(where: { $0.id == id }) {
                bookings[index] = updatedBooking
            }
            
            print("Successfully updated booking: \(id)")
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = "Error updating booking: \(error.localizedDescription)"
            print("Error updating booking: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
            return false
        }
    }
    
    // MARK: - Delete booking
    func deleteBooking(id: UUID) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            print("Deleting booking: \(id)")
            
            // Remove the booking from server table
            try await bookingAPIService.deleteBooking(id: id)
            
            // Remove the booking from local list
            bookings.removeAll { $0.id == id }
            
            print("Successfully deleted booking: \(id)")
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = "Error deleting booking: \(error.localizedDescription)"
            print("Error deleting booking: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
            return false
        }
    }
    
    // MARK: - Convenience methods for status updates
    
    func acceptBooking(id: UUID) async -> Bool {
        return await updateBooking(id: id, status: "accepted")
    }
    
    func rejectBooking(id: UUID) async -> Bool {
        return await updateBooking(id: id, status: "rejected")
    }
    
    func cancelBooking(id: UUID) async -> Bool {
        return await updateBooking(id: id, status: "cancelled")
    }
    
    // MARK: - Utility methods
    
    func getBookings(withStatus status: String) -> [BookingResponseDTO] {
        return bookings.filter { $0.status?.lowercased() == status.lowercased() }
    }
    
    /// Get pending bookings
    var pendingBookings: [BookingResponseDTO] {
        return getBookings(withStatus: "pending")
    }
    
    /// Get accepted bookings
    var acceptedBookings: [BookingResponseDTO] {
        return getBookings(withStatus: "accepted")
    }
    
    /// Get rejected bookings
    var rejectedBookings: [BookingResponseDTO] {
        return getBookings(withStatus: "rejected")
    }
    
    /// Clear error message
    func clearErrorMessage() {
        errorMessage = nil
    }
}
