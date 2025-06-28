//
//  Languages.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import Foundation

enum AvailableLanguage: String, Codable, Identifiable, CaseIterable {
    case english
    case spanish
    case french
    case german
    case chinese
    case japanese
    case arabic
    case hindi
    case dutch
    case italian
    
    // South african official languages
    case afrikaans
    case ndebele
    case xhosa
    case zulu 
    case sepedi
    case sesotho
    case setswana
    case swati
    case tshivenda
    case xitsonga 
    // Add more languages as needed
    
    var id: String {
        return self.rawValue
    }
}

enum ProficiencyLevel: String, Codable {
    case beginner
    case intermediate
    case advanced
    case native
}

struct Language: Codable, Identifiable {
    var id = UUID()
    var name: AvailableLanguage
    var level: ProficiencyLevel
}

