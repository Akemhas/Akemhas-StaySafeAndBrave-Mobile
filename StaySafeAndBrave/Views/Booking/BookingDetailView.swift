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
    let currentUserProfile: Profile
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
    
    @State private var newDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerCard
                    bookingDetailsCard
                    
                    if booking.isPending {
                        actionButtons
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
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            HStack {
                AsyncImage(url: URL(string: booking.displayImage)) { image in
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
                    
                    Text(booking.mentorName ?? "Unknown Mentor")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text(booking.displayLocation)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                StatusBadge(status: booking.status ?? "unknown")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var bookingDetailsCard: some View {
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
                    value: booking.displayLocation
                )
                
                DetailRow(
                    icon: "person.circle",
                    title: "Booking ID",
                    value: booking.id?.uuidString.prefix(8).uppercased() ?? "Unknown"
                )
                
                DetailRow(
                    icon: "person.2",
                    title: currentUserProfile.role == .mentor ? "Student" : "Mentor",
                    value: currentUserProfile.role == .mentor ?
                        (booking.userName ?? "Unknown User") :
                        (booking.mentorName ?? "Unknown Mentor")
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
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
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
            
            if currentUserProfile.role == .mentor {
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
                    onDismiss?()
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
                status: "accepted"
            )
            
            await MainActor.run {
                isUpdating = false
                if success {
                    dismiss()
                    onDismiss?()
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
                status: "pending"
            )
            
            await MainActor.run {
                isUpdating = false
                if success {
                    showingRescheduleSheet = false
                    dismiss()
                    onDismiss?()
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
            userName: "John Doe",
            mentorName: "Jane Smith",
            mentorLocation: "Cape Town",
            mentorImage: "https://example.com/image.jpg",
            date: "30/06/2025",
            status: "pending",
            description: "Looking forward to meeting you!"
        ),
        currentUserProfile: Profile.testMentor
    )
}
