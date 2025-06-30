//
//  RegisterView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 15.06.25.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var profile: Profile
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var cpassword: String = ""
    @State private var birth_date: Date = {
        // Default to 25 years ago (reasonable adult age)
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    }()
    @State private var selectedRole: Role = .user
    
    // API integration states
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var useAPI = true
    @State private var successMessage: String?
    @State private var showingSuccess = false
    
    private let userAPIService = UserAPIService.shared
    
    var isValid: Bool {
        let basicFieldsValid = ![name, email, password, cpassword].contains(where: \.isEmpty)
        let passwordsMatch = password == cpassword
        let emailValid = email.contains("@")
        let ageValid = isAtLeast18YearsOld
        return basicFieldsValid && passwordsMatch && emailValid && ageValid
    }
    
    var isAtLeast18YearsOld: Bool {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birth_date, to: Date())
        return (ageComponents.year ?? 0) >= 18
    }
    
    var currentAge: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birth_date, to: Date())
        return ageComponents.year ?? 0
    }
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        // Maximum age: 100 years ago
        let startComponents = DateComponents(year: calendar.component(.year, from: Date()) - 100)
        // Minimum age: 18 years ago (must be at least 18)
        let endComponents = DateComponents(year: calendar.component(.year, from: Date()) - 18, month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()))
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }
    
    var body: some View {
        Form {
            Group{
                TextField(
                    "Name",
                    text: $name,
                )
                .textContentType(.username)
                TextField(
                    "E-Mail",
                    text: $email,
                )
                .textContentType(.emailAddress)
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            Group{
                SecureField("Password", text: $password)
                    .textContentType(.oneTimeCode)
                SecureField("Repeat Password", text: $cpassword)
                    .textContentType(.oneTimeCode)
                
                if !cpassword.isEmpty && password != cpassword {
                    Text("Passwords don't match")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            DisclosureGroup("Birthdate: \(birth_date.formatted(date: .long, time: .omitted))"){
                DatePicker("Birthdate:",
                           selection: $birth_date,
                           in: dateRange,
                           displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                
                // Age validation feedback
                HStack {
                    Image(systemName: isAtLeast18YearsOld ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(isAtLeast18YearsOld ? .green : .red)
                    
                    if isAtLeast18YearsOld {
                        Text("Age: \(currentAge) years ✓")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("Must be at least 18 years old (Currently \(currentAge))")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 4)
            }
            
            // Debug section
            #if DEBUG
            Section("Debug") {
                Toggle("Use API", isOn: $useAPI)
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                if let successMessage = successMessage {
                    Text("Success: \(successMessage)")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            #endif
            
            Button{
                registerUser()
            }
            label:{
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Registering...")
                    } else {
                        Text("Register")
                    }
                }
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill((isValid && !isLoading) ? .teal : .gray)
                }
            }
            .disabled(!isValid || isLoading)
            
            // Age requirement notice
            if !isAtLeast18YearsOld {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    Text("You must be at least 18 years old to create an account")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            
            Spacer().frame(height: 50)
                .listRowSeparator(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationTitle("Register")
        .alert("Registration Error", isPresented: $showingError) {
            Button("OK") {
                clearMessages()
            }
        } message: {
            Text(errorMessage ?? "Unknown error occurred")
        }
        .alert("Registration Successful", isPresented: $showingSuccess) {
            Button("Continue") {
                dismiss()
            }
        } message: {
            Text(successMessage ?? "Account created successfully!")
        }
    }
    
    private func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    private func registerUser() {
        clearMessages()
        
        if !useAPI {
            // Local registration
            profile = Profile.register(
                _name: name,
                _email: email,
                _role: selectedRole,
                _birth_date: birth_date,
            )
            successMessage = "Account created locally"
            showingSuccess = true
            return
        }
        
        // API registration
        isLoading = true
        
        Task {
            do {
                print("Starting registration for: \(email)")
                
                let registrationDTO = UserRegistrationDTO(
                    name: name,
                    email: email,
                    password: password,
                    role: selectedRole,
                    birth_date: birth_date
                )
                
                let authResponse = try await userAPIService.register(data: registrationDTO)
                
                await MainActor.run {
                    isLoading = false
                    
                    if authResponse.isSuccess, let user = authResponse.user {
                        print("Registration successful for user: \(user.name ?? "Unknown")")
                        
                        print("DEBUG: User ID from response: \(user.id?.uuidString ?? "NIL")")
                        print("DEBUG: Selected role: \(selectedRole)")
                        print("DEBUG: User role from response: \(user.role ?? "NIL")")
                        
                        let newProfile = user.toProfile()
                        
                        profile = newProfile
                        
                        successMessage = "Account created successfully! Welcome, \(user.name ?? "User")!"
                        showingSuccess = true
                        
                    } else {
                        print("❌ Registration failed: \(authResponse.message ?? "Unknown error")")
                        errorMessage = authResponse.message ?? "Registration failed - please try again"
                        showingError = true
                    }
                }
                
            } catch let apiError as APIError {
                await MainActor.run {
                    isLoading = false
                    print("❌ API Error during registration: \(apiError)")
                    
                    switch apiError {
                    case .invalidResponse(let statusCode, let message):
                        if statusCode == 400 {
                            errorMessage = "Email already exists. Please try a different email address."
                        } else {
                            errorMessage = message ?? "Server error (\(statusCode))"
                        }
                    case .networkError(let urlError):
                        errorMessage = "Network error: \(urlError.localizedDescription)"
                    case .decodingError:
                        errorMessage = "Server response error. Please try again."
                    default:
                        errorMessage = apiError.errorDescription ?? "Registration failed"
                    }
                    
                    showingError = true
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    print("❌ Unexpected error during registration: \(error)")
                    errorMessage = "Unexpected error: \(error.localizedDescription)"
                    showingError = true
                }
            }
        }
    }
}

#Preview {
    RegisterView(profile: .constant(Profile.empty))
}
