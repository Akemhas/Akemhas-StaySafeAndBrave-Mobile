//
//  Package.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import Foundation
import SwiftData

@Model
final class Package {
    @Attribute(.unique) var package_id: UUID
    var title: String
    var heading: String
    var details: String
    var price: Float
    
    init(
        package_id: UUID = UUID(),
        title: String,
        heading: String,
        details: String,
        price: Float
    ) {
        self.package_id = package_id
        self.title = title
        self.heading = heading
        self.details = details
        self.price = price
    }
}
