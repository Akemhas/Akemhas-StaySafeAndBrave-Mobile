//
//  DiaryView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI

struct DiaryView: View {
    var body: some View {
        VStack {
            Text("Diary View")
                .font(.largeTitle)
                .navigationTitle("Diary")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    DiaryView()
        .modelContainer(for: Mentor.self, inMemory: true)
}
