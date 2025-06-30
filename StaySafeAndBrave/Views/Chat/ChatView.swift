//
//  ChatView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack {
            Text("Chat View")
                .font(.largeTitle)
                .navigationTitle("Chat")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ChatView()
        .modelContainer(for: Mentor.self, inMemory: true)
}
