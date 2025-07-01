//
//  MentorViewModel.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 18.06.25.

import SwiftUI
import SwiftData

@MainActor
final class MentorViewModel: ObservableObject {
    var modelContext: ModelContext?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let mentorAPIService = MentorAPIService.shared
    
    func onAppear(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await fetchMentors()
        }
    }
    
    // MARK: - Fetch all mentors
    func fetchMentors() async {
        guard let context = modelContext else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("Starting to fetch mentors...")
            
            let remoteMentors = try await mentorAPIService.fetchMentors()
            
            print("Successfully fetched \(remoteMentors.count) mentors from API")
            
            // Clear existing mentors first
            try context.delete(model: Mentor.self)
            
            for data in remoteMentors {
                let mentor = data.toMentorModel()
                context.insert(mentor)
                print("Inserted mentor: \(mentor.name)")
            }
            
            try context.save()
            print("Successfully saved \(remoteMentors.count) mentors to local database")
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error fetching mentors: \(error.localizedDescription)"
            print("Error fetching mentors: \(error)")
            
            // If it's an API error, show more detailed info
            if let apiError = error as? APIError {
                print("API Error details: \(apiError.errorDescription ?? "Unknown")")
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Fetch single mentor
    func fetchMentor(id: UUID) async {
        guard let context = modelContext else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("Fetching mentor with ID: \(id)")
            
            let dto = try await mentorAPIService.fetchMentor(id: id)
            let mentor = dto.toMentorModel()
            
            context.insert(mentor)
            try context.save()
            
            print("Successfully fetched and saved mentor: \(mentor.name)")
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error fetching mentor: \(error.localizedDescription)"
            print("Error fetching mentor: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Create mentor
    func createMentor(userID: UUID, name: String, profile_image: String? = nil,
                      score: Float? = nil, birth_date: Date, bio: String? = nil,
                      languages: [AvailableLanguage]? = nil, hobbies: [Hobby]? = nil,
                      location: City? = nil) async {
        guard let context = modelContext else { return }
        
        isLoading = true
        errorMessage = nil
        
        let createDTO = MentorCreateDTO(
            userID: userID,
            name: name,
            profile_image: profile_image,
            score: score,
            birth_date: birth_date,
            bio: bio,
            languages: languages,
            hobbies: hobbies,
            location: location
        )
        
        do {
            print("Creating mentor: \(name)")
            
            let createdData = try await mentorAPIService.createMentor(data: createDTO)
            let mentor = createdData.toMentorModel()
            
            context.insert(mentor)
            try context.save()
            
            print("Successfully created mentor: \(mentor.name)")
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error creating mentor: \(error.localizedDescription)"
            print("Error creating mentor: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Update mentor
    func updateMentor(mentor: Mentor, name: String? = nil, profile_image: String? = nil,
                      score: Float? = nil, birth_date: Date? = nil, bio: String? = nil,
                      languages: [AvailableLanguage]? = nil, hobbies: [Hobby]? = nil,
                      location: City? = nil) async {
        guard let context = modelContext else { return }
        
        isLoading = true
        errorMessage = nil
        
        let updateDTO = MentorUpdateDTO(
            name: name,
            profile_image: profile_image,
            score: score,
            birth_date: birth_date,
            bio: bio,
            languages: languages,
            hobbies: hobbies,
            location: location
        )
        
        do {
            print("Updating mentor: \(mentor.name)")
            
            let updatedData = try await mentorAPIService.updateMentor(id: mentor.id, data: updateDTO)
            
            // Update local model with server response
            mentor.name = updatedData.name ?? mentor.name
            mentor.profile_image = updatedData.profile_image ?? mentor.profile_image
            mentor.score = updatedData.score ?? mentor.score
            mentor.birth_date = updatedData.birthDateAsDate ?? mentor.birth_date
            mentor.bio = updatedData.bio ?? mentor.bio
            mentor.languages = updatedData.frontendLanguages ?? mentor.languages
            mentor.hobbies = updatedData.frontendHobbies ?? mentor.hobbies
            mentor.location = updatedData.frontendLocation ?? mentor.location
            mentor.timestamp_last_update = Date()
            
            try context.save()
            
            print("Successfully updated mentor: \(mentor.name)")
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error updating mentor: \(error.localizedDescription)"
            print("Error updating mentor: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Delete mentor
    func deleteMentor(mentor: Mentor) async {
        guard let context = modelContext else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("Deleting mentor: \(mentor.name)")
            
            try await mentorAPIService.deleteMentor(id: mentor.id)
            context.delete(mentor)
            try context.save()
            
            print("Successfully deleted mentor: \(mentor.name)")
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error deleting mentor: \(error.localizedDescription)"
            print("Error deleting mentor: \(error)")
            
            if let apiError = error as? APIError {
                errorMessage = apiError.errorDescription
            }
        }
    }
    
    // MARK: - Refresh mentors (For Pull-to-Refresh)
    func refreshMentors() async {
        await fetchMentors()
    }
    
    func clearErrorMessage() {
        errorMessage = nil
    }
}
