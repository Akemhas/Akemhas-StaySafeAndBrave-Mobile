//
//  APIDebugView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import SwiftUI

struct APIDebugView: View {
    @StateObject private var apiConfig = APIConfiguration.shared
    @State private var showingHealthCheck = false
    @State private var healthStatus: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Current Environment") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: apiConfig.currentEnvironment.isSecure ? "lock.shield" : "network")
                                .foregroundColor(apiConfig.currentEnvironment.isSecure ? .green : .orange)
                            Text(apiConfig.currentEnvironment.rawValue)
                                .font(.headline)
                        }
                        
                        Text(apiConfig.currentEnvironment.baseURL)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(apiConfig.currentEnvironment.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Switch Environment") {
                    ForEach(APIEnvironment.allCases, id: \.self) { environment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(environment.rawValue)
                                    .font(.subheadline)
                                Text(environment.baseURL)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if apiConfig.currentEnvironment == environment {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            apiConfig.switchTo(environment)
                            apiConfig.saveEnvironment()
                        }
                    }
                }
                
                Section("Health Check") {
                    Button("Test Connection") {
                        testConnection()
                    }
                    
                    if !healthStatus.isEmpty {
                        Text(healthStatus)
                            .font(.caption)
                            .foregroundColor(healthStatus.contains("✅") ? .green : .red)
                    }
                }
                
                Section("Debug Actions") {
                    Button("Auto-Detect Environment") {
                        apiConfig.autoDetectEnvironment()
                        apiConfig.saveEnvironment()
                    }
                    
                    Button("Reset to Default") {
                        #if DEBUG
                        apiConfig.switchTo(.local)
                        #else
                        apiConfig.switchTo(.production)
                        #endif
                        apiConfig.saveEnvironment()
                    }
                }
                
                #if DEBUG
                Section("Debug Info") {
                    Text(apiConfig.debugInfo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                #endif
            }
            .navigationTitle("API Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                apiConfig.loadSavedEnvironment()
            }
        }
    }
    
    private func testConnection() {
        healthStatus = "Testing connection..."
        
        Task {
            do {
                // First try a simple health check
                let url = apiConfig.baseURL
                let request = URLRequest(url: url)
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        await MainActor.run {
                            healthStatus = "✅ Base URL accessible (Status: \(httpResponse.statusCode))"
                        }
                        
                        // Now try mentors endpoint
                        try await testMentorsEndpoint()
                    } else {
                        await MainActor.run {
                            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                            healthStatus = "❌ Base URL returned \(httpResponse.statusCode): \(responseString)"
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    healthStatus = "❌ Connection failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func testMentorsEndpoint() async throws {
        do {
            let mentors = try await MentorAPIService.shared.fetchMentors()
            await MainActor.run {
                healthStatus = "✅ Full API working! Found \(mentors.count) mentors"
            }
        } catch {
            await MainActor.run {
                healthStatus = "❌ Mentors endpoint failed: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Quick Access Button for Debug Builds

#if DEBUG
struct APIDebugButton: View {
    @State private var showingDebugView = false
    
    var body: some View {
        Button {
            showingDebugView = true
        } label: {
            Image(systemName: "gear.badge")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingDebugView) {
            APIDebugView()
        }
    }
}
#endif

#Preview {
    APIDebugView()
}
