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
    @Environment(\.dismiss) private var dismiss
    @State private var showingCancelAlert = false
    @State private var isUpdating = false
    
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
                                    title: "Message",
                                    value: description
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Action Buttons
                    if booking.status?.lowercased() == "pending" {
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
                            
                            Button(action: {
                                // TODO: Implement reschedule functionality
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
        .alert("Cancel Booking", isPresented: $showingCancelAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                cancelBooking()
            }
        } message: {
            Text("Are you sure you want to cancel this booking? This action cannot be undone.")
        }
    }
    
    private func cancelBooking() {
        isUpdating = true
        
        // TODO: Uncomment when backend supports booking updates
        /*
        Task {
            let success = await bookingViewModel.cancelBooking(id: booking.id ?? UUID())
            
            await MainActor.run {
                isUpdating = false
                if success {
                    dismiss()
                }
            }
        }
        */
        
        // Simulate API call for now
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isUpdating = false
            dismiss()
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
    BookingDetailView(booking: BookingResponseDTO(
        id: UUID(),
        userID: UUID(),
        mentorID: UUID(),
        date: "30/06/2025",
        status: "pending",
        description: "Looking forward to meeting you!"
    ))
}
