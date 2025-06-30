//
//  EmptyBookingsView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/1/25.
//

import SwiftUI
import SwiftData

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

