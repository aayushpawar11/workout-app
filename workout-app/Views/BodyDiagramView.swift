import SwiftUI

struct BodyDiagramView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    
    var targetedMuscleGroups: Set<MuscleGroup> {
        Set(workout.exercises.flatMap { $0.muscleGroups })
    }
    
    var targetedDetailedMuscles: [DetailedMuscle] {
        workout.exercises.flatMap { $0.detailedMuscles }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.1),
                        Color(red: 0.1, green: 0.1, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 8) {
                            Text(workout.name)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("\(workout.exercises.count) exercises")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        // Exercise Breakdown Card
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Exercise Breakdown")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(workout.exercises) { exercise in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(exercise.name)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    if !exercise.detailedMuscles.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 10) {
                                                ForEach(exercise.detailedMuscles, id: \.self) { muscle in
                                                    HStack(spacing: 6) {
                                                        Circle()
                                                            .fill(muscle.color)
                                                            .frame(width: 14, height: 14)
                                                            .shadow(color: muscle.color.opacity(0.5), radius: 3)
                                                        Text(muscle.rawValue)
                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        Capsule()
                                                            .fill(muscle.color.opacity(0.25))
                                                            .overlay(
                                                                Capsule()
                                                                    .stroke(muscle.color.opacity(0.5), lineWidth: 1)
                                                            )
                                                    )
                                                }
                                            }
                                            .padding(.horizontal, 4)
                                        }
                                    } else {
                                        Text("No muscle analysis available")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.1))
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.ultraThinMaterial)
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Body Diagram")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    BodyDiagramView(workout: Workout(name: "Upper Day 1", exercises: [
        Exercise(name: "Incline Bench Press", muscleGroups: [.chest, .triceps, .shoulders], detailedMuscles: [.upperChest, .anteriorDeltoids, .triceps])
    ]))
}
