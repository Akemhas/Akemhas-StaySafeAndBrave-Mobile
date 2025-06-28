//
//  Booking.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import Foundation
import SwiftData

@Model
final class Booking {
    @Attribute(.unique) var booking_id: UUID
    var date: Date
    var status: String  // "pending", "accepted", or "rejected"
    
    // Relationships
    @Relationship(deleteRule: .cascade) var user: User
    @Relationship(deleteRule: .cascade) var mentor: User
    @Relationship(deleteRule: .cascade) var package: Package

    init(
        booking_id: UUID = UUID(),
        date: Date,
        status: String,
        user: User,
        mentor: User,
        package: Package
    ) {
        self.booking_id = booking_id
        self.date = date
        self.status = status
        self.user = user
        self.mentor = mentor
        self.package = package
    }
}
