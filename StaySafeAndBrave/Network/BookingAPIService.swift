//
//  BookingAPIService.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

class BookingAPIService: BaseAPIService {
    
    // MARK: - Singleton
    
    static let shared = BookingAPIService()
    
    private override init() {
        super.init()
    }
    
    // MARK: - API Endpoints
    
    private struct Endpoints {
        static let bookings = "/bookings"
        static func userBookings(userID: UUID) -> String {
            return "/bookings/\(userID.uuidString)"
        }
        static func booking(id: UUID) -> String {
            return "/bookings/\(id.uuidString)"
        }
    }
    
    // MARK: - Booking API Methods
    
    /// Create a new booking
    func createBooking(data: BookingCreateDTO) async throws -> BookingResponseDTO {
        print("Creating new booking...")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            return try await performRequest(
                endpoint: Endpoints.bookings,
                method: .POST,
                body: body,
                responseType: BookingResponseDTO.self
            )
        } catch {
            print("Failed to encode booking data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Fetch all bookings for a specific user
    func fetchUserBookings(userID: UUID) async throws -> [BookingResponseDTO] {
        print("Fetching bookings for user: \(userID.uuidString)")
        
        return try await performRequest(
            endpoint: Endpoints.userBookings(userID: userID),
            method: .GET,
            responseType: [BookingResponseDTO].self
        )
    }
    
    /// Update an existing booking
    func updateBooking(id: UUID, data: BookingUpdateDTO) async throws -> BookingResponseDTO {
        print("Updating booking with ID: \(id.uuidString)")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            return try await performRequest(
                endpoint: Endpoints.booking(id: id),
                method: .PUT,
                body: body,
                responseType: BookingResponseDTO.self
            )
        } catch {
            print("Failed to encode booking update data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Delete a booking
    func deleteBooking(id: UUID) async throws {
        print("Deleting booking with ID: \(id.uuidString)")
        
        let _: EmptyResponse = try await performRequest(
            endpoint: Endpoints.booking(id: id),
            method: .DELETE,
            responseType: EmptyResponse.self
        )
        
        print("Booking deleted successfully")
    }
    
    /// Accept a booking (convenience method for status update)
    func acceptBooking(id: UUID) async throws -> BookingResponseDTO {
        print("Accepting booking with ID: \(id.uuidString)")
        
        let updateData = BookingUpdateDTO(status: "accepted")
        return try await updateBooking(id: id, data: updateData)
    }
    
    /// Reject a booking (convenience method for status update)
    func rejectBooking(id: UUID) async throws -> BookingResponseDTO {
        print("Rejecting booking with ID: \(id.uuidString)")
        
        let updateData = BookingUpdateDTO(status: "rejected")
        return try await updateBooking(id: id, data: updateData)
    }
    
    /// Cancel a booking (convenience method for status update)
    func cancelBooking(id: UUID) async throws -> BookingResponseDTO {
        print("Cancelling booking with ID: \(id.uuidString)")
        
        let updateData = BookingUpdateDTO(status: "cancelled")
        return try await updateBooking(id: id, data: updateData)
    }
}
