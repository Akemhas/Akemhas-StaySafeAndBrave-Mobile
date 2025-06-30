//
//  FilterPill.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/30/25.
//

import SwiftUI

struct FilterPill: View {
    let text: String
    let isSelected: Bool
    let count: Int?
    let action: () -> Void
    
    init(text: String, isSelected: Bool, count: Int? = nil, action: @escaping () -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.count = count
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(text)
                    .font(.caption)
                    .fontWeight(.medium)
                
                if let count = count, count > 0 {
                    Text("(\(count))")
                        .font(.caption2)
                        .opacity(0.8)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
