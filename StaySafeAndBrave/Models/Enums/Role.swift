//
//  Role.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 15.06.25.
//

enum Role: String, Codable, CaseIterable, Identifiable{
    case user
    case mentor
    
    var id: String {
        return self.rawValue
    }
}
