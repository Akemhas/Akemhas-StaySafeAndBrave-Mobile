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
                    placeholder: "Search mentors...",
                    onFilter: openFilterOptions,
                    onSearch: applySearch,
                    showDebugButton: false,
                    onDebugButton: refreshMentors
                )
                
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
    }
    
    func refreshMentors() {
        Task {
            await refreshMentorsFromAPI()
        }
    }
    
    private func refreshMentorsFromAPI() async {
        await mentorViewModel.fetchMentors()
    }
    
    private var filterOptionsView: some View {
        NavigationView {
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
                
                Section("Sort By") {
                    Picker("Sort Options", selection: $sortOrder) {
                        Text("Name A-Z").tag(SortDescriptor(\Mentor.name, order: .forward))
                        Text("Name Z-A").tag(SortDescriptor(\Mentor.name, order: .reverse))
                        Text("Score: Low to High").tag(SortDescriptor(\Mentor.score, order: .forward))
                        Text("Score: High to Low").tag(SortDescriptor(\Mentor.score, order: .reverse))
                        Text("Age: Youngest First").tag(SortDescriptor(\Mentor.birth_date, order: .reverse))
                        Text("Age: Oldest First").tag(SortDescriptor(\Mentor.birth_date, order: .forward))
                        Text("Location").tag(SortDescriptor(\Mentor.location_for_sorting, order: .forward))
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button("Reset All Filters") {
                        selectedCity = nil
                        selectedLanguage = nil
                        minScore = 0.0
                        maxScore = 5.0
                        searchText = ""
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingFilterOptions = false
                    }
                }
            }
        }
    }
    
    private func setupMentorViewModel() {
        mentorViewModel.onAppear(modelContext: modelContext)
    }
}
