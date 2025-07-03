//
//  APIDebugView.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//

import SwiftUI

struct APIDebugView: View {
    @StateObject private var apiConfig = APIConfiguration.shared
    @State private var testResult: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("API Debug")
                .font(.title)
                .padding()
            
            Text(apiConfig.debugInfo)
                .font(.monospaced(.caption)())
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            VStack(spacing: 12) {
                Button("Test Current Environment") {
                    Task {
                        let isReachable = await apiConfig.testCurrentEnvironment()
                        testResult = isReachable ? "Reachable" : "Not Reachable"
                    }
                }
                .buttonStyle(.bordered)
            }
            
            if !testResult.isEmpty {
                Text(testResult)
                    .padding()
            }
            
            Picker("Environment", selection: $apiConfig.currentEnvironment) {
                ForEach(APIEnvironment.allCases, id: \.self) { env in
                    Text(env.rawValue).tag(env)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    APIDebugView()
}
