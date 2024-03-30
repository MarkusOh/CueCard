//
//  CardApp.swift
//  Card
//
//  Created by Seungsub Oh on 3/23/24.
//

import SwiftUI
import SwiftData

@main
struct CardApp: App {
    var body: some Scene {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: Stack.self, configurations: config)
        
        return scene
            .modelContainer(container)
    }
    
    var scene: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
