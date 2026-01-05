import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    @State var workout: Workout
    @State private var showingAddExercise = false
    @State private var showingDeleteAlert = false
    
    // Calculate muscle intensity (how many exercises target each muscle)
    var muscleIntensity: [DetailedMuscle: Int] {
        var intensity: [DetailedMuscle: Int] = [:]
        for exercise in workout.exercises {
            for muscle in exercise.detailedMuscles {
                intensity[muscle, default: 0] += 1
            }
        }
        return intensity
    }
    
    var body: some View {
        ZStack {
            // Dark background matching the image
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                    // Header
                    Text(workout.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                
                // Exercise List
                if workout.exercises.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No Exercises Yet")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        Text("Tap the + button to add exercises")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(workout.exercises) { exercise in
                            NavigationLink(destination: ExerciseTrackingView(exercise: exercise, workout: workout)) {
                                ExerciseCard(exercise: exercise)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        dataStore.deleteExercise(exercise, from: workout)
                                        workout.exercises.removeAll { $0.id == exercise.id }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(workout: $workout)
        }
        .alert("Delete Workout", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataStore.deleteWorkout(workout)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(workout.name)\"? This action cannot be undone.")
        }
        .onChange(of: workout) { newValue in
            dataStore.updateWorkout(newValue)
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    @EnvironmentObject var dataStore: WorkoutDataStore
    
    // Get latest log for this exercise
    var latestLog: WorkoutLog? {
        dataStore.getLogsForExercise(exercise.id).last
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                if let log = latestLog {
                    Text("\(log.sets)x\(log.reps)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                } else {
                    Text("3x10")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            if let log = latestLog, log.weight > 0 {
                Text("\(Int(log.weight)) lbs")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.yellow)
            } else {
                Text("-")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.15))
        )
    }
}

#Preview {
    NavigationView {
        WorkoutDetailView(workout: Workout(name: "Pull", exercises: [
            Exercise(name: "Pull-ups", muscleGroups: [.back], detailedMuscles: [.lats, .biceps]),
            Exercise(name: "Cable Row", muscleGroups: [.back], detailedMuscles: [.lats, .midBack])
        ]))
        .environmentObject(WorkoutDataStore())
    }
}
