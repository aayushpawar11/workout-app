import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    @State private var workoutName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Workout Name", text: $workoutName)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Workout Details")
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !workoutName.isEmpty {
                            let workout = Workout(name: workoutName)
                            dataStore.addWorkout(workout)
                            dismiss()
                        }
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddWorkoutView()
        .environmentObject(WorkoutDataStore())
}

