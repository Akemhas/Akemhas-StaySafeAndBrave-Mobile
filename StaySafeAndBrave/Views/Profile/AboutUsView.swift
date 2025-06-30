//
//  AboutUsView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 14.06.25.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        VStack {
            Text("About Us View")
                .font(.largeTitle)
                .navigationTitle("About Us")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    AboutUsView()
}
