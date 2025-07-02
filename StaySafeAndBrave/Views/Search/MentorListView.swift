//
//  MentorListView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 06.06.25.
// This view is needed to perform the sorting/filtering

import SwiftData
import SwiftUI

struct MentorListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Mentor.score) var mentors: [Mentor]
    // Send a request to the backend to load all mentors (fetch)
    @Binding var profile: Profile
    @Binding var activeTab: BottomNavBar.ActiveTab
    
    var body: some View {
        List (mentors){
            mentor in NavigationLink(destination: MentorDetailView(mentor: mentor, profile: $profile, activeTab: $activeTab)){
                MentorRowListView(mentor:mentor)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init())
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
    /// The initializer receives the sortdescriptor and the filtering options. Also the bindings of profile and activetab for the redirection.
    init(sort: SortDescriptor<Mentor>,
         searchText: String = "",
         selectedCity: String? = nil,
         selectedLanguage: AvailableLanguage? = nil,
         minScore: Float = 0.0,
         maxScore: Float = 10.0,
         profile: Binding<Profile>,
         activeTab: Binding<BottomNavBar.ActiveTab>) {
        
        // passing the binding
        self._profile = profile
        self._activeTab = activeTab
        // Build predicate based on filters
        var predicates: [Predicate<Mentor>] = []
        
        // Search text filter (searches in name and bio)
        if !searchText.isEmpty {
            let searchPredicate = #Predicate<Mentor> { mentor in
                mentor.name.localizedStandardContains(searchText) ||
                mentor.bio.localizedStandardContains(searchText) ||
                mentor.location_for_sorting?.localizedStandardContains(searchText) ?? false
            }
            predicates.append(searchPredicate)
        }
        
        // City filter
        if let selectedCity = selectedCity {
            let cityPredicate = #Predicate<Mentor> { mentor in
                mentor.location_for_sorting == selectedCity
            }
            predicates.append(cityPredicate)
        }
        
        // Language filter
        if let selectedLanguage = selectedLanguage {
            let languagePredicate = #Predicate<Mentor> { mentor in
                mentor.languages?.contains(selectedLanguage) == true
            }
            predicates.append(languagePredicate)
        }
        
        
        
        // Score range filter
        let scorePredicate = #Predicate<Mentor> { mentor in
            mentor.score >= minScore && mentor.score <= maxScore
        }
        predicates.append(scorePredicate)
        
        // Combine all predicates
        let finalPredicate: Predicate<Mentor>?
        if predicates.isEmpty {
            finalPredicate = nil
        } else if predicates.count == 1 {
            finalPredicate = predicates[0]
        } else {
            finalPredicate = predicates.dropFirst().reduce(predicates[0]) { result, predicate in
                #Predicate<Mentor> { mentor in
                    result.evaluate(mentor) && predicate.evaluate(mentor)
                }
            }
        }
        
        // Initialize the Query with sort and filter
        if let predicate = finalPredicate {
            _mentors = Query(filter: predicate, sort: [sort])
        } else {
            _mentors = Query(sort: [sort])
        }
    }
}

#Preview {
    MentorListView(sort: SortDescriptor(\Mentor.name), profile: .constant(Profile.testMentor), activeTab: .constant(.search))
}
