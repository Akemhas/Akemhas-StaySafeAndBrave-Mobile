//
//  BookingView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI
import SwiftData

struct BookingView: View {
    @State private var searchText: String = ""

    private let sampleBookings = [
        BookingItem(location: "Cape Town", date: "July 1", isCompleted: false),
        BookingItem(location: "Duisburg", date: "July 5", isCompleted: true),
        BookingItem(location: "Johannesburg", date: "July 8", isCompleted: false),
        BookingItem(location: "Kamp Lintfort", date: "January 2", isCompleted: false),
        BookingItem(location: "Istanbul", date: "August 8", isCompleted: false),
        BookingItem(location: "Izmir", date: "August 15", isCompleted: false),
    ]
    
    var filteredBookings: [BookingItem] {
        if(searchText.isEmpty){
            return sampleBookings
        }
        else{
            return sampleBookings.filter { booking in booking.location.localizedCaseInsensitiveContains(searchText)
                || booking.date.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(searchText: $searchText, placeholder: "Search Booking...",
                      onFilter: openFilterOptions,
                      onSearch: applySearch)
                
            List(filteredBookings) {
                booking in BookingRow(booking: booking)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
    
    func openFilterOptions(){
        
    }
    func applySearch(){
        
    }
}

// This is experimental don't look at it so much. It will change soon
struct BookingRow: View {
    let booking: BookingItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: booking.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(booking.isCompleted ? .green : Color.accentColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.location)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(booking.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

struct BookingItem: Identifiable {
    let id = UUID()
    let location: String
    let date: String
    let isCompleted: Bool
}

#Preview {
    BookingView()
        .modelContainer(for: [Mentor.self, Booking.self], inMemory: true)
}
