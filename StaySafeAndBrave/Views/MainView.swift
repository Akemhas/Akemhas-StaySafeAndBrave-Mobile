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
                case .booking:
                    if profile.isLoggedIn {
                        BookingView(profile: profile)
                    } else {
                        LoginPromptView {
                            activeTab = .profile
                        }
                    }
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
        }
        .onAppear {
            loadSavedProfile()
        }
        .onChange(of: profile) { _, newProfile in
            // Save profile whenever it changes (login/logout/update)
            if newProfile.isLoggedIn {
                newProfile.save()
            } else {
                Profile.clearSaved()
            }
        }
    }
    
    private func loadSavedProfile() {
        let savedProfile = Profile.load()
        if savedProfile.isLoggedIn {
            profile = savedProfile
            print("Restored user session: \(savedProfile.name ?? "Unknown")")
        } else {
            print("No valid session found, user needs to login")
        }
    }
}

struct LoginPromptView: View {
    let onLoginTap: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "person.badge.key")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Login Required")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Please log in to view your bookings")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Button("Go to Profile") {
                    onLoginTap()
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.teal)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    MainView()
        .modelContainer(for: Mentor.self, inMemory: true)
}
