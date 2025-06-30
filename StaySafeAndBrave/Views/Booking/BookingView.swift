//
//  BookingView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI
import SwiftData

struct BookingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var bookingViewModel = BookingViewModel()
    @State private var searchText: String = ""
    @State private var selectedFilter: BookingFilter = .all
    @State private var showingErrorAlert = false
    
    @State private var selectedBooking: BookingResponseDTO?
    
    var profile: Profile
    
    enum BookingFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case accepted = "Accepted"
        case rejected = "Rejected"
        case cancelled = "Cancelled"
    }
    
    var filteredBookings: [BookingResponseDTO] {
        let bookingsToFilter: [BookingResponseDTO]
        
        switch selectedFilter {
        case .all:
            bookingsToFilter = bookingViewModel.bookings
        case .pending:
            bookingsToFilter = bookingViewModel.bookings.filter {
                $0.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "pending"
            }
        case .accepted:
            bookingsToFilter = bookingViewModel.bookings.filter {
                $0.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "accepted"
            }
        case .rejected:
            bookingsToFilter = bookingViewModel.bookings.filter {
                $0.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "rejected"
            }
        case .cancelled:
            bookingsToFilter = bookingViewModel.bookings.filter {
                $0.status?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "cancelled"
            }
        }
        
        if searchText.isEmpty {
            return bookingsToFilter
        } else {
            return bookingsToFilter.filter { booking in
                booking.status?.localizedCaseInsensitiveContains(searchText) == true ||
                booking.description?.localizedCaseInsensitiveContains(searchText) == true ||
                booking.dateDisplay?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(
                searchText: $searchText,
                placeholder: "Search Bookings...",
                onFilter: {},
                onSearch: applySearch,
                showDebugButton: false,
                showFilterButton: false,
                onDebugButton: {}
            )
            
            if !bookingViewModel.bookings.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(BookingFilter.allCases, id: \.self) { filter in
                            FilterPill(
                                text: filter.rawValue,
                                isSelected: selectedFilter == filter
                            ) {
                                selectedFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
            
            if bookingViewModel.isLoading {
                Spacer()
                ProgressView("Loading bookings...")
                    .font(.headline)
                Spacer()
            } else if filteredBookings.isEmpty {
                EmptyBookingsView(filter: selectedFilter)
            } else {
                List(filteredBookings, id: \.id) { booking in
                    BookingRow(booking: booking) {
                        // Set the selected booking - this will trigger the sheet
                        selectedBooking = booking
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .refreshable {
                    await refreshBookings()
                }
            }
        }
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            bookingViewModel.onAppear(modelContext: modelContext)
            Task {
                await loadBookings()
            }
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK") {
                bookingViewModel.clearErrorMessage()
            }
        } message: {
            Text(bookingViewModel.errorMessage ?? "Unknown error occurred")
        }
        .onChange(of: bookingViewModel.errorMessage) { _, newValue in
            showingErrorAlert = newValue != nil
        }
        .sheet(item: $selectedBooking, onDismiss: {
            selectedBooking = nil
        }) { booking in
            BookingDetailView(booking: booking){
                Task{
                    await loadBookings()
                }
            }
        }
    }
    
    private func loadBookings() async {
        guard let userID = UUID(uuidString: profile.user_id) else {
            print("Invalid user ID: \(profile.user_id)")
            return
        }
        
        await bookingViewModel.fetchUserBookings(userID: userID)
    }
    
    private func refreshBookings() async {
        await loadBookings()
    }
    
    func applySearch() {
    }
}

#Preview {
    BookingView(profile: Profile.testMentor)
        .modelContainer(for: [Mentor.self, Booking.self], inMemory: true)
}
