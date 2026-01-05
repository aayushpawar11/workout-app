import SwiftUI

struct ExerciseTrackingView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    let exercise: Exercise
    let workout: Workout
    @State private var sets: Int = 3
    @State private var reps: Int = 10
    @State private var weight: Double = 0.0
    @State private var showingLogHistory = false
    @FocusState private var isWeightFocused: Bool
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise Header
                    VStack(spacing: 8) {
                        Text(exercise.name)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        if !exercise.muscleGroups.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(exercise.muscleGroups, id: \.self) { group in
                                        Text(group.rawValue)
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(group.color.opacity(0.2))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(group.color.opacity(0.5), lineWidth: 1)
                                                    )
                                            )
                                            .foregroundColor(group.color)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                    
                    // Workout Details
                    VStack(spacing: 20) {
                        // Sets
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sets")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Stepper("\(sets)", value: $sets, in: 1...10)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(white: 0.15))
                                .cornerRadius(12)
                        }
                        
                        // Reps
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reps")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Stepper("\(reps)", value: $reps, in: 1...50)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(white: 0.15))
                                .cornerRadius(12)
                        }
                        
                        // Weight
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight (lbs)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            TextField("0", value: $weight, format: .number)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color(white: 0.15))
                                .cornerRadius(12)
                                .focused($isWeightFocused)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: saveWorkout) {
                        Text("Save Workout")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(weight > 0 ? Color.yellow : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(weight <= 0)
                    .padding(.horizontal)
                    
                    // View Progress Button
                    Button(action: { showingLogHistory = true }) {
                        HStack {
                            Text("View Progress")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(white: 0.15))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
            }
        }
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
        isWeightFocused = false
    }
}

#Preview {
    NavigationView {
        ExerciseTrackingView(
            exercise: Exercise(name: "Bench Press", muscleGroups: [.chest, .triceps], detailedMuscles: []),
            workout: Workout(name: "Upper Day 1")
        )
        .environmentObject(WorkoutDataStore())
    }
}
