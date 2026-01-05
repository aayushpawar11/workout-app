import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                WorkoutListView()
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell.fill")
                    }
                    .tag(0)
                
                GraphView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(1)
            }
            .tint(.yellow)
        }
        .onAppear {
            // Ensure dataStore is initialized
            print("ContentView appeared, workouts count: \(dataStore.workouts.count)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutDataStore())
}
