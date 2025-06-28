//
//  MainView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI

struct MainView: View {
    @State private var activeTab: BottomNavBar.ActiveTab = .search
    @State private var profile: Profile = Profile.empty
    @State private var mentorViewModel: MentorViewModel = MentorViewModel()
    
    // Debug states
    #if DEBUG
    @State private var showingAPIDebug = false
    @StateObject private var apiConfig = APIConfiguration.shared
    #endif
    
    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch activeTab {
                case .search: SearchView(mentorViewModel: $mentorViewModel, profile: $profile, activeTab: $activeTab)
                case .chat: ChatView()
                case .booking: BookingView()
                case .diary: DiaryView()
                case .profile: ProfileView(activeTab: $activeTab, profile: $profile)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                Spacer()
                BottomNavBar(activeTab: $activeTab) { newTab in
                    activeTab = newTab
                }
            }
            
            // Debug overlay in top-right corner (only in DEBUG builds)
            #if DEBUG
            VStack {
                HStack {
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        // API Environment indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(apiConfig.currentEnvironment.isSecure ? .green : .orange)
                                .frame(width: 6, height: 6)
                            Text(apiConfig.currentEnvironment.rawValue)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        
                        // Debug button
                        Button {
                            showingAPIDebug = true
                        } label: {
                            Image(systemName: "gear.badge")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(.regularMaterial)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 50) // Account for status bar
                
                Spacer()
            }
            .sheet(isPresented: $showingAPIDebug) {
                APIDebugView()
            }
            #endif
        }
        .onAppear {
            #if DEBUG
            // Load saved API environment on app start
            apiConfig.loadSavedEnvironment()
            #endif
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Mentor.self, inMemory: true)
}
