//
//  LoginView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 15.06.25.
//

import SwiftUI

enum Field: Hashable {
    case username
    case password
}

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var profile: Profile
    @FocusState private var focusedField: Field?
    @State private var email: String = ""
    @State private var password: String = ""
    
    // API integration states
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    private let userAPIService = UserAPIService.shared
    
    var isValid: Bool {
        ![email, password].contains(where: \.isEmpty) && email.contains("@")
    }
    
    var body: some View {
        VStack {
            
            TextField(
                "E-Mail",
                text: $email,
            )
            .focused($focusedField, equals: .username)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .padding()
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.teal, lineWidth: 2)
            }
            .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding()
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.teal, lineWidth: 2)
                }
                .padding(.horizontal)
            
            Button{
                loginUser()
            }
            label:{
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Signing In...")
                    } else {
                        Text("Sign In")
                    }
                }
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill((isValid && !isLoading) ? .teal : .gray)
                }
                .padding(.horizontal)
            }
            .disabled(!isValid || isLoading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationTitle("Login")
        .alert("Login Error", isPresented: $showingError) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Unknown error occurred")
        }
        .onSubmit {
            if focusedField == .username {
                focusedField = .password
            } else {
                if isValid {
                    loginUser()
                }
            }
        }
    }
    
    private func loginUser() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let authResponse = try await userAPIService.login(email: email, password: password)
                
                if authResponse.isSuccess, let user = authResponse.user {
                    // Create profile from API response
                    let newProfile = user.toProfile()
                    
                    await MainActor.run {
                        profile = newProfile
                        // Profile will be automatically saved due to onChange in MainView
                        isLoading = false
                        dismiss()
                    }
                    
                    print("Successfully logged in user: \(user.name ?? "Unknown")")
                } else {
                    await MainActor.run {
                        isLoading = false
                        errorMessage = authResponse.message ?? "Login failed"
                        showingError = true
                    }
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.errorDescription
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    showingError = true
                    print("Login failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    LoginView(profile: .constant(Profile.empty))
}
