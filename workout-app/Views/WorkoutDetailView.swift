import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @State var workout: Workout
    @State private var showingAddExercise = false
    @State private var showingBodyDiagram = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Body Diagram Button
                Button(action: { showingBodyDiagram = true }) {
                    HStack {
                        Image(systemName: "figure.stand")
                        Text("View Body Diagram")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Exercises List
                if workout.exercises.isEmpty {
                    Text("No exercises yet. Add your first exercise!")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(workout.exercises) { exercise in
                        NavigationLink(destination: ExerciseTrackingView(exercise: exercise, workout: workout)) {
                            ExerciseRowView(exercise: exercise)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddExercise = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(workout: $workout)
        }
        .sheet(isPresented: $showingBodyDiagram) {
            BodyDiagramView(workout: workout)
        }
        .onChange(of: workout) { newValue in
            dataStore.updateWorkout(newValue)
        }
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .font(.headline)
            HStack {
                ForEach(exercise.muscleGroups, id: \.self) { group in
                    Text(group.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(group.color.opacity(0.2))
                        .foregroundColor(group.color)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        WorkoutDetailView(workout: Workout(name: "Upper Day 1", exercises: [
            Exercise(name: "Bench Press", muscleGroups: [.chest, .triceps, .shoulders])
        ]))
        .environmentObject(WorkoutDataStore())
    }
}

