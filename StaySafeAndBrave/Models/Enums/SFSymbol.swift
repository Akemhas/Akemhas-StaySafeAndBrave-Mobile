//
//  SwiftUIView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 15.05.25.
//

import SwiftUI

enum SFSymbol: String, View {
    case new = "plus"
    case search = "magnifyingglass"
    case filter = "slider.horizontal.3"
    case star = "star"
    case chat = "bubble.left"
    case booking = "calendar"
    case profile = "person"
    case diary = "book"
    case settings = "gearshape"
    case refresh = "arrow.clockwise"
    case sort = "arrow.up.arrow.down.circle"
    case addToCalendar = "calendar.badge.plus"
    case addDummyData = "plus.circle"
    case backArrow = "arrow.left.circle.fill"
    case sendMessage = "paperplane.circle.fill"
    
    var body: some View {
        Image(systemName: rawValue)
    }
}

#Preview {
    SFSymbol.sendMessage
        
}
