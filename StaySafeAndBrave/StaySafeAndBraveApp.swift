//
//  StaySafeAndBraveApp.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 14.05.25.
//

import SwiftUI
import SwiftData

@main
struct StaySafeAndBraveApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Mentor.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
