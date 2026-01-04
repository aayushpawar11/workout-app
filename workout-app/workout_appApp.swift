import SwiftUI

@main
struct workout_appApp: App {
    @StateObject private var dataStore = WorkoutDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}

