import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    @State private var workoutName = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("New Workout")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !workoutName.isEmpty {
                            let workout = Workout(name: workoutName)
                            dataStore.addWorkout(workout)
                            dismiss()
                        }
                    }
                    .disabled(workoutName.isEmpty)
                    .foregroundColor(workoutName.isEmpty ? .gray : .yellow)
                }
                .padding()
                
                TextField("Workout Name", text: $workoutName)
                    .textInputAutocapitalization(.words)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(white: 0.15))
                    .cornerRadius(12)
                    .padding()
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .onAppear {
                        // Focus immediately when view appears
                        DispatchQueue.main.async {
                            isTextFieldFocused = true
                        }
                    }
                
                Spacer()
            }
        }
    }
}

#Preview {
    AddWorkoutView()
        .environmentObject(WorkoutDataStore())
}
