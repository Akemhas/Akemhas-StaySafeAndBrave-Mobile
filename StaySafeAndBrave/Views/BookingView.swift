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
            bookingsToFilter = bookingViewModel.pendingBookings
        case .accepted:
            bookingsToFilter = bookingViewModel.acceptedBookings
        case .rejected:
            bookingsToFilter = bookingViewModel.rejectedBookings
        case .cancelled:
            bookingsToFilter = bookingViewModel.getBookings(withStatus: "cancelled")
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
            // Search and Filter Bar
            VStack(spacing: 10) {
                SearchBar(
                    searchText: $searchText,
                    placeholder: "Search Bookings...",
                    onFilter: openFilterOptions,
                    onSearch: applySearch
                )
                
                // Filter Pills
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
    }
    
    private func loadBookings() async {
        guard let userID = UUID(uuidString: profile.user_id) else {
            print("❌ Invalid user ID: \(profile.user_id)")
            return
        }
        
        await bookingViewModel.fetchUserBookings(userID: userID)
    }
    
    private func refreshBookings() async {
        await loadBookings()
    }
    
    func openFilterOptions() {
        // You can implement a sheet with more advanced filter options if needed
    }
    
    func applySearch() {
        // Search is applied automatically through the computed property
    }
}

// MARK: - Supporting Views

struct FilterPill: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
    }
}

struct EmptyBookingsView: View {
    let filter: BookingView.BookingFilter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No \(filter.rawValue.lowercased()) bookings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(emptyMessage)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyMessage: String {
        switch filter {
        case .all:
            return "You haven't made any bookings yet. Find a mentor and book your first session!"
        case .pending:
            return "No pending bookings. Your booking requests will appear here."
        case .accepted:
            return "No accepted bookings yet. Once a mentor accepts your request, it will appear here."
        case .rejected:
            return "No rejected bookings. This is where declined requests would appear."
        case .cancelled:
            return "No cancelled bookings."
        }
    }
}

struct BookingRow: View {
    let booking: BookingResponseDTO
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Status Indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Booking")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(booking.statusDisplay)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(statusColor.opacity(0.2))
                            .foregroundColor(statusColor)
                            .cornerRadius(8)
                    }
                    
                    if let dateDisplay = booking.dateDisplay {
                        Text(dateDisplay)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let description = booking.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .lineLimit(2)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var statusColor: Color {
        switch booking.status?.lowercased() {
        case "pending":
            return .orange
        case "accepted":
            return .green
        case "rejected":
            return .red
        case "cancelled":
            return .gray
        default:
            return .blue
        }
    }
}

#Preview {
    BookingView(profile: Profile.testMentor)
        .modelContainer(for: [Mentor.self, Booking.self], inMemory: true)
}
