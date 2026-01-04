import SwiftUI

struct ExerciseTrackingView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    let exercise: Exercise
    let workout: Workout
    @State private var sets: Int = 3
    @State private var reps: Int = 10
    @State private var weight: Double = 0.0
    @State private var showingLogHistory = false
    
    var body: some View {
        Form {
            Section {
                Text(exercise.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Muscle Groups:")
                    ForEach(exercise.muscleGroups, id: \.self) { group in
                        Text(group.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(group.color.opacity(0.2))
                            .foregroundColor(group.color)
                            .cornerRadius(5)
                    }
                }
            }
            
            Section {
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Stepper("Reps: \(reps)", value: $reps, in: 1...50)
                HStack {
                    Text("Weight (lbs):")
                    Spacer()
                    TextField("0", value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                }
            } header: {
                Text("Workout Details")
            }
            
            Section {
                Button(action: saveWorkout) {
                    HStack {
                        Spacer()
                        Text("Save Workout")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(weight <= 0)
            }
            
            Section {
                Button(action: { showingLogHistory = true }) {
                    HStack {
                        Text("View Progress")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .navigationTitle("Track Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLogHistory) {
            ExerciseProgressView(exercise: exercise)
        }
    }
    
    private func saveWorkout() {
        let log = WorkoutLog(
            exerciseId: exercise.id,
            exerciseName: exercise.name,
            sets: sets,
            reps: reps,
            weight: weight
        )
        dataStore.logWorkout(log)
        
        // Reset for next set
        weight = 0.0
    }
}

#Preview {
    NavigationView {
        ExerciseTrackingView(
            exercise: Exercise(name: "Bench Press", muscleGroups: [.chest, .triceps]),
            workout: Workout(name: "Upper Day 1")
        )
        .environmentObject(WorkoutDataStore())
    }
}

