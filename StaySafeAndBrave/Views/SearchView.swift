//
//  ContentView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 14.05.25.

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText: String = ""
    @State private var sortOrder = SortDescriptor(\Mentor.location_for_sorting, order: .forward)
    @State private var showingFilterOptions = false
    
    // Filter States
    @State private var selectedCity: String?
    @State private var selectedLanguage: AvailableLanguage?
    @State private var minScore: Float = 0.0
    @State private var maxScore: Float = 5.0
    
    // API sync
    @Binding var mentorViewModel: MentorViewModel
    @Binding var profile: Profile
    @Binding var activeTab: BottomNavBar.ActiveTab
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    searchText: $searchText,
                    placeholder: "Search Mentor...",
                    onFilter: openFilterOptions,
                    onSearch: applySearch,
                    onAddDummies: refreshMentors
                )
                
                HStack(spacing: 0) {
                    MentorListView(
                        sort: sortOrder,
                        searchText: searchText,
                        selectedCity: selectedCity,
                        selectedLanguage: selectedLanguage,
                        minScore: minScore,
                        maxScore: maxScore,
                        profile: $profile,
                        activeTab: $activeTab
                    )
                    .background(Color(.systemBackground))
                }
            }
            .padding(.bottom)
        }
        .onAppear(perform: setupMentorViewModel)
        .sheet(isPresented: $showingFilterOptions) {
            filterOptionsView
        }
        .refreshable {
            await refreshMentorsFromAPI()
        }
    }
    
    func openFilterOptions() {
        showingFilterOptions = true
    }
    
    func applySearch() {
        // Search is handled by MentorListView filtering
        // No need to delete local data
    }
    
    func refreshMentors() {
        Task {
            await refreshMentorsFromAPI()
        }
    }
    
    private func refreshMentorsFromAPI() async {
        await mentorViewModel.fetchMentors()
    }
    
    // MARK: Filter options
    private var filterOptionsView: some View {
        Form {
            Section("Location") {
                Picker("City", selection: $selectedCity) {
                    Text("All Cities").tag(nil as String?)
                    ForEach(City.allCases, id: \.self) { city in
                        Text(city.rawValue.capitalized).tag(city.rawValue)
                    }
                }
            }
            
            Section("Language") {
                Picker("Language", selection: $selectedLanguage) {
                    Text("All Languages").tag(nil as AvailableLanguage?)
                    ForEach(AvailableLanguage.allCases, id: \.self) { language in
                        Text(language.rawValue.capitalized).tag(AvailableLanguage?.some(language))
                    }
                }
            }
            
            Section("Score Range") {
                HStack {
                    Text("Min: \(minScore, specifier: "%.1f")")
                    Slider(value: $minScore, in: 0...5, step: 0.1)
                }
                
                HStack {
                    Text("Max: \(maxScore, specifier: "%.1f")")
                    Slider(value: $maxScore, in: 0...5, step: 0.1)
                }
            }
            
            Section {
                Button("Reset Filters") {
                    selectedCity = nil
                    selectedLanguage = nil
                    minScore = 0.0
                    maxScore = 5.0
                }
                .foregroundColor(.red)
            }
            
            // MARK: Sort options in filter
            Section("Sort By") {
                Picker("Sort Options", selection: $sortOrder) {
                    Text("Name ascending").tag(SortDescriptor(\Mentor.name, order: .forward))
                    Text("Name descending").tag(SortDescriptor(\Mentor.name, order: .reverse))
                    Text("Score ascending").tag(SortDescriptor(\Mentor.score, order: .forward))
                    Text("Score descending").tag(SortDescriptor(\Mentor.score, order: .reverse))
                    Text("Age ascending").tag(SortDescriptor(\Mentor.birth_date, order: .reverse))
                    Text("Age descending").tag(SortDescriptor(\Mentor.birth_date, order: .forward))
                    Text("Location").tag(SortDescriptor(\Mentor.location_for_sorting, order: .forward))
                }
                .pickerStyle(.menu)
            }
            
            Button("Done") {
                showingFilterOptions = false
            }
        }
    }
    
    // MARK: API Synchronization
    private func setupMentorViewModel() {
        mentorViewModel.onAppear(modelContext: modelContext)
    }
}

#Preview {
    SearchView(
        mentorViewModel: .constant(.init()),
        profile: .constant(Profile.testMentor),
        activeTab: .constant(.search)
    )
    .modelContainer(for: Mentor.self, inMemory: true)
}
