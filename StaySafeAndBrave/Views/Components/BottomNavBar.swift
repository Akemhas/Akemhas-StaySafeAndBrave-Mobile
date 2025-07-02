//
//  BottomNavBar.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var activeTab: ActiveTab
    var action: (ActiveTab) -> Void
    
    enum ActiveTab: String, CaseIterable {
        case search, chat, booking, diary, profile
    }

    var body: some View {
        HStack {
            ForEach(ActiveTab.allCases, id: \.self) { tab in
                Button {
                    if(tab != .chat && tab != .diary){
                        action(tab)
                    }
                } label: {
                    VStack {
                        tab.icon
                        Text(tab.label)
                    }
                    .foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .background(.bar)
    }
}

extension BottomNavBar.ActiveTab {
    var icon: some View {
        switch self {
        case .search: SFSymbol.search
        case .chat: SFSymbol.chat
        case .booking: SFSymbol.booking
        case .diary: SFSymbol.diary
        case .profile: SFSymbol.profile
        }
    }
    
    var label: String {
        self.rawValue.capitalized
    }
}
