//
//  BookingRow.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/1/25.
//

import SwiftUI
import SwiftData

struct BookingRow: View {
    let booking: BookingResponseDTO
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
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
