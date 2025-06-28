//
//  Hobby.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

enum Hobby: String, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    var description: String{
        rawValue.capitalized
    }
    
    case coding
    case hiking
    case reading
    case cooking
    case photography
    case gaming
    case traveling
    case drawing
    case music 
    
    var id: String {
        return self.rawValue
    }
}
