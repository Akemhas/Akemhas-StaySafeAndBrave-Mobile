//
//  City.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 28.05.25.
// add here more cases when new cities for the mentors are needed

enum City: String, Codable, CaseIterable, CustomStringConvertible, Identifiable{
    var description: String {
        switch self{
        case .capetown: return "Cape Town"
        case .johannesburg: return "Johannesburg"
        case .durban: return "Durban"
        case .dortmund: return "Dortmund"
        }
    }
    
    case capetown
    case johannesburg
    case durban
    case dortmund 
    
    var id: String {
        return self.rawValue
    }
}
