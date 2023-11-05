//  TodoWithSwiftDataApp.swift
//  TodoWithSwiftData
//
//  Created by Sorata on 2023/09/02.
//

import SwiftUI
import SwiftData

@main
struct TodoWithSwiftDataApp: App {
    
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(for: Todo.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
