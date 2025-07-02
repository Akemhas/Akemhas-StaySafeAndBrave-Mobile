//
//  BookingDetailView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/1/25.
//

import SwiftUI
import SwiftData

struct BookingDetailView: View {
    let booking: BookingResponseDTO
    let currentUserProfile: Profile // Add this to pass the current user's profile
    var onDismiss: (() -> Void)? = nil
    @StateObject private var bookingViewModel = BookingViewModel()

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingCancelAlert = false
    @State private var showingAcceptAlert = false
    @State private var showingRescheduleSheet = false
    @State private var isUpdating = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String?
    
    // Reschedule states
    @State private var newDate = Date()
    @State private var rescheduleMessage = ""
    
    // Dummy data - replace with API calls when backend is ready
    private let dummyMentorName = "John Doe"
    private let dummyMentorLocation = "Cape Town"
    private let dummyMentorImage = "https://hochschule-rhein-waal.sciebo.de/s/zKzF7MWJatLpR5P/download"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    VStack(spacing: 16) {
                        HStack {
                            // Mentor Image
                            AsyncImage(url: URL(string: dummyMentorImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Booking with")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(dummyMentorName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Image(systemName: "location")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                    Text(dummyMentorLocation)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        // Status Badge
                        HStack {
                            Spacer()
                            StatusBadge(status: booking.status ?? "unknown")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Booking Details Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Booking Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DetailRow(
                                icon: "calendar",
                                title: "Date & Time",
                                value: booking.dateDisplay ?? "No date specified"
                            )
                            
                            DetailRow(
                                icon: "mappin.and.ellipse",
                                title: "Location",
                                value: dummyMentorLocation
                            )
                            
                            DetailRow(
                                icon: "person.circle",
                                title: "Booking ID",
                                value: booking.id?.uuidString.prefix(8).uppercased() ?? "Unknown"
                            )
                            
                            if let description = booking.description, !description.isEmpty {
                                DetailRow(
                                    icon: "text.alignleft",
                                    title: "Description",
                                    value: description
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Action Buttons - Role-based
                    if booking.status?.lowercased() == "pending" {
                        VStack(spacing: 12) {
                            // Cancel button - available for both users and mentors
                            Button(action: {
                                showingCancelAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("Cancel Booking")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(isUpdating)
                            
                            // Role-specific buttons
                            if currentUserProfile.role == .mentor {
                                // Accept button - only for mentors
                                Button(action: {
                                    showingAcceptAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle")
                                        Text("Accept Booking")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .disabled(isUpdating)
                            } else {
                                // Reschedule button - only for regular users
                                Button(action: {
                                    showingRescheduleSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar.badge.clock")
                                        Text("Reschedule")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .disabled(isUpdating)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            bookingViewModel.onAppear(modelContext: modelContext)
        }
        .alert("Cancel Booking", isPresented: $showingCancelAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                cancelBooking()
            }
        } message: {
            Text("Are you sure you want to cancel this booking? This action cannot be undone.")
        }
        .alert("Accept Booking", isPresented: $showingAcceptAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Accept", role: .none) {
                acceptBooking()
            }
        } message: {
            Text("Are you sure you want to accept this booking?")
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Unknown error occurred")
        }
        .sheet(isPresented: $showingRescheduleSheet) {
            rescheduleBookingView
        }
    }
    
    private var rescheduleBookingView: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Reschedule Booking") {
                        DatePicker(
                            "New Date & Time",
                            selection: $newDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                    }
                }

                Spacer()

                Button(action: rescheduleBooking) {
                    HStack {
                        if isUpdating {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Updating...")
                        } else {
                            Text("Reschedule Booking")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isUpdating ? Color.gray.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.horizontal, .bottom])
                }
                .disabled(isUpdating)
            }
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingRescheduleSheet = false
                    }
                }
            }
        }
    }
    
    private func cancelBooking() {
        guard let bookingId = booking.id else {
            errorMessage = "Invalid booking ID"
            showingErrorAlert = true
            return
        }
        
        isUpdating = true
        
        Task {
            let success = await bookingViewModel.cancelBooking(id: bookingId)
            
            await MainActor.run {
                isUpdating = false
                if success {
                    dismiss()
                } else {
                    errorMessage = bookingViewModel.errorMessage ?? "Failed to cancel booking"
                    showingErrorAlert = true
                }
            }
        }
    }
    
    private func acceptBooking() {
        guard let bookingId = booking.id else {
            errorMessage = "Invalid booking ID"
            showingErrorAlert = true
            return
        }
        
        isUpdating = true
        
        Task {
            let success = await bookingViewModel.updateBooking(
                id: bookingId,
                date: booking.date != nil ? DateFormatter().date(from: booking.date!) ?? Date() : Date(),
                status: "accepted"
            )
            
            await MainActor.run {
                isUpdating = false
                if success {
                    dismiss()
                    onDismiss?() // Call this to notify BookingView to update its content
                } else {
                    errorMessage = bookingViewModel.errorMessage ?? "Failed to accept booking"
                    showingErrorAlert = true
                }
            }
        }
    }
    
    private func rescheduleBooking() {
        guard let bookingId = booking.id else {
            errorMessage = "Invalid booking ID"
            showingErrorAlert = true
            return
        }
        
        isUpdating = true
        
        Task {
            let success = await bookingViewModel.updateBooking(
                id: bookingId,
                date: newDate,
                status: "pending" // Reset to pending after reschedule
            )
            
            await MainActor.run {
                  isUpdating = false
                  if success {
                      showingRescheduleSheet = false
                      dismiss()
                      onDismiss?() // Call this to notify BookingView to update it's content
                  } else {
                      errorMessage = bookingViewModel.errorMessage ?? "Failed to reschedule booking"
                      showingErrorAlert = true
                  }
              }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.teal)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch status.lowercased() {
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
    BookingDetailView(
        booking: BookingResponseDTO(
            id: UUID(),
            userID: UUID(),
            mentorID: UUID(),
            date: "30/06/2025",
            status: "pending",
            description: "Looking forward to meeting you!"
        ),
        currentUserProfile: Profile.testMentor
    )
}
