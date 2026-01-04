import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    @Binding var workout: Workout
    @State private var exerciseName = ""
    @State private var selectedMuscleGroups: Set<MuscleGroup> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Exercise Name", text: $exerciseName)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Exercise Details")
                }
                
                Section {
                    ForEach(MuscleGroup.allCases, id: \.self) { group in
                        Button(action: {
                            if selectedMuscleGroups.contains(group) {
                                selectedMuscleGroups.remove(group)
                            } else {
                                selectedMuscleGroups.insert(group)
                            }
                        }) {
                            HStack {
                                Text(group.rawValue)
                                Spacer()
                                if selectedMuscleGroups.contains(group) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                } header: {
                    Text("Muscle Groups")
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !exerciseName.isEmpty && !selectedMuscleGroups.isEmpty {
                            let exercise = Exercise(
                                name: exerciseName,
                                muscleGroups: Array(selectedMuscleGroups)
                            )
                            dataStore.addExercise(exercise, to: workout)
                            workout.exercises.append(exercise)
                            dismiss()
                        }
                    }
                    .disabled(exerciseName.isEmpty || selectedMuscleGroups.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddExerciseView(workout: .constant(Workout(name: "Test")))
        .environmentObject(WorkoutDataStore())
}

