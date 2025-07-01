//
//  MentorAPIService.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.

import Foundation

class MentorAPIService: BaseAPIService {
    
    // MARK: - Singleton
    
    static let shared = MentorAPIService()
    
    private override init() {
        super.init()
    }
    
    // MARK: - API Endpoints
    
    private struct Endpoints {
        static let mentors = "/mentors"
        static func mentor(id: UUID) -> String {
            return "/mentors/\(id.uuidString)"
        }
    }
    
    // MARK: - Mentor API Methods
    
    /// Fetch all mentors from the backend
    func fetchMentors() async throws -> [MentorResponseDTO] {
        print("Fetching all mentors...")
        
        return try await performRequest(
            endpoint: Endpoints.mentors,
            method: .GET,
            responseType: [MentorResponseDTO].self
        )
    }
    
    /// Fetch a single mentor by ID
    func fetchMentor(id: UUID) async throws -> MentorResponseDTO {
        print("Fetching mentor with ID: \(id.uuidString)")
        
        return try await performRequest(
            endpoint: Endpoints.mentor(id: id),
            method: .GET,
            responseType: MentorResponseDTO.self
        )
    }
    
    /// Create a new mentor
    func createMentor(data: MentorCreateDTO) async throws -> MentorResponseDTO {
        print("Creating new mentor...")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            return try await performRequest(
                endpoint: Endpoints.mentors,
                method: .POST,
                body: body,
                responseType: MentorResponseDTO.self
            )
        } catch {
            print("Failed to encode mentor data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Update an existing mentor
    func updateMentor(id: UUID, data: MentorUpdateDTO) async throws -> MentorResponseDTO {
        print("Updating mentor with ID: \(id.uuidString)")
        
        do {
            let body = try JSONEncoder.apiEncoder.encode(data)
            
            return try await performRequest(
                endpoint: Endpoints.mentor(id: id),
                method: .PUT,
                body: body,
                responseType: MentorResponseDTO.self
            )
        } catch {
            print("Failed to encode mentor update data: \(error)")
            throw APIError.encodingError(error)
        }
    }
    
    /// Delete a mentor
    func deleteMentor(id: UUID) async throws {
        print("Deleting mentor with ID: \(id.uuidString)")
        
        let _: EmptyResponse = try await performRequest(
            endpoint: Endpoints.mentor(id: id),
            method: .DELETE,
            responseType: EmptyResponse.self
        )
        
        print("Mentor deleted successfully")
    }
}
