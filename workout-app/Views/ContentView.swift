import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @State private var selectedTab = 0
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutDataStore())
}

