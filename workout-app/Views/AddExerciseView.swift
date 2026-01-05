import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @Environment(\.dismiss) var dismiss
    @Binding var workout: Workout
    @State private var exerciseName = ""
    @State private var selectedMuscleGroups: Set<MuscleGroup> = []
    @State private var detailedMuscles: [DetailedMuscle] = []
    @State private var isAnalyzing = false
    @State private var analysisError: String?
    @FocusState private var isTextFieldFocused: Bool
    
    private let geminiService = GeminiService()
    
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
                    
                    Text("Add Exercise")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !exerciseName.isEmpty {
                            let finalMuscleGroups = selectedMuscleGroups.isEmpty ? autoSelectMuscleGroups(from: detailedMuscles) : Array(selectedMuscleGroups)
                            
                            let exercise = Exercise(
                                name: exerciseName,
                                muscleGroups: finalMuscleGroups,
                                detailedMuscles: detailedMuscles
                            )
                            dataStore.addExercise(exercise, to: workout)
                            workout.exercises.append(exercise)
                            dismiss()
                        }
                    }
                    .disabled(exerciseName.isEmpty)
                    .foregroundColor(exerciseName.isEmpty ? .gray : .yellow)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exercise Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            TextField("Enter exercise name", text: $exerciseName)
                                .textInputAutocapitalization(.words)
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(white: 0.15))
                                .cornerRadius(12)
                                .focused($isTextFieldFocused)
                                .submitLabel(.done)
                                .onAppear {
                                    // Focus immediately when view appears
                                    DispatchQueue.main.async {
                                        isTextFieldFocused = true
                                    }
                                }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Button(action: analyzeExercise) {
                            HStack {
                                if isAnalyzing {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.white)
                                } else {
                                    Image(systemName: "brain.head.profile")
                                        .font(.title3)
                                }
                                Text(isAnalyzing ? "Analyzing..." : "Analyze with AI")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(white: 0.15))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(exerciseName.isEmpty || isAnalyzing)
                        .padding(.horizontal)
                        
                        if let error = analysisError {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text(error)
                                    .font(.system(size: 13))
                                    .foregroundColor(.orange)
                            }
                            .padding(12)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        if !detailedMuscles.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.yellow)
                                    Text("AI-Detected Muscles")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 10) {
                                    ForEach(detailedMuscles, id: \.self) { muscle in
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(muscle.color)
                                                .frame(width: 10, height: 10)
                                            Text(muscle.rawValue)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color(white: 0.2))
                                        )
                                    }
                                }
                            }
                            .padding()
                            .background(Color(white: 0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Muscle Groups (Optional)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(MuscleGroup.allCases, id: \.self) { group in
                                Button(action: {
                                    if selectedMuscleGroups.contains(group) {
                                        selectedMuscleGroups.remove(group)
                                    } else {
                                        selectedMuscleGroups.insert(group)
                                    }
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(group.color)
                                            .frame(width: 10, height: 10)
                                        Text(group.rawValue)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        Spacer()
                                        if selectedMuscleGroups.contains(group) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.yellow)
                                                .font(.title3)
                                        }
                                    }
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
    
    private func analyzeExercise() {
        guard !exerciseName.isEmpty else { return }
        
        isAnalyzing = true
        analysisError = nil
        
        Task {
            do {
                let muscles = try await geminiService.analyzeExercise(exerciseName)
                await MainActor.run {
                    detailedMuscles = muscles
                    selectedMuscleGroups = Set(autoSelectMuscleGroups(from: muscles))
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    // Provide fallback based on exercise name
                    detailedMuscles = fallbackMuscleAnalysis(exerciseName)
                    selectedMuscleGroups = Set(autoSelectMuscleGroups(from: detailedMuscles))
                    isAnalyzing = false
                    if detailedMuscles.isEmpty {
                        analysisError = "Analysis failed. Please select muscles manually."
                    }
                }
            }
        }
    }
    
    // Fallback muscle analysis based on exercise name keywords
    private func fallbackMuscleAnalysis(_ name: String) -> [DetailedMuscle] {
        let lowercased = name.lowercased()
        var muscles: [DetailedMuscle] = []
        
        // Chest exercises
        if lowercased.contains("incline") && (lowercased.contains("press") || lowercased.contains("bench")) {
            muscles.append(contentsOf: [.upperChest, .anteriorDeltoids, .triceps])
        } else if lowercased.contains("decline") && (lowercased.contains("press") || lowercased.contains("bench")) {
            muscles.append(contentsOf: [.lowerChest, .anteriorDeltoids, .triceps])
        } else if lowercased.contains("bench") || lowercased.contains("press") {
            muscles.append(contentsOf: [.midChest, .anteriorDeltoids, .triceps])
        } else if lowercased.contains("chest") {
            muscles.append(contentsOf: [.midChest, .upperChest])
        }
        
        // Back exercises
        if lowercased.contains("pull") || lowercased.contains("row") || lowercased.contains("lat") {
            muscles.append(contentsOf: [.lats, .midBack, .biceps])
        } else if lowercased.contains("shrug") {
            muscles.append(contentsOf: [.traps])
        } else if lowercased.contains("back") {
            muscles.append(contentsOf: [.lats, .midBack])
        }
        
        // Shoulder exercises
        if lowercased.contains("shoulder") || lowercased.contains("deltoid") {
            muscles.append(contentsOf: [.anteriorDeltoids, .lateralDeltoids])
        } else if lowercased.contains("lateral") {
            muscles.append(contentsOf: [.lateralDeltoids])
        } else if lowercased.contains("rear") || lowercased.contains("posterior") {
            muscles.append(contentsOf: [.posteriorDeltoids])
        }
        
        // Arm exercises
        if lowercased.contains("curl") {
            muscles.append(contentsOf: [.biceps, .forearms])
        } else if lowercased.contains("tricep") || lowercased.contains("dip") {
            muscles.append(contentsOf: [.triceps])
        } else if lowercased.contains("bicep") {
            muscles.append(contentsOf: [.biceps])
        }
        
        // Leg exercises
        if lowercased.contains("squat") {
            muscles.append(contentsOf: [.quads, .glutes, .lowerBack])
        } else if lowercased.contains("deadlift") {
            muscles.append(contentsOf: [.hamstrings, .glutes, .lowerBack, .traps])
        } else if lowercased.contains("leg") || lowercased.contains("quad") {
            muscles.append(contentsOf: [.quads])
        } else if lowercased.contains("hamstring") {
            muscles.append(contentsOf: [.hamstrings])
        } else if lowercased.contains("calf") {
            muscles.append(contentsOf: [.calves])
        }
        
        // Core exercises
        if lowercased.contains("crunch") || lowercased.contains("situp") {
            muscles.append(contentsOf: [.upperAbs])
        } else if lowercased.contains("plank") {
            muscles.append(contentsOf: [.upperAbs, .lowerAbs])
        } else if lowercased.contains("oblique") {
            muscles.append(contentsOf: [.obliques])
        } else if lowercased.contains("abs") || lowercased.contains("core") {
            muscles.append(contentsOf: [.upperAbs, .lowerAbs])
        }
        
        return Array(Set(muscles)) // Remove duplicates
    }
    
    private func autoSelectMuscleGroups(from detailedMuscles: [DetailedMuscle]) -> [MuscleGroup] {
        var groups: Set<MuscleGroup> = []
        
        for muscle in detailedMuscles {
            switch muscle {
            case .upperChest, .midChest, .lowerChest:
                groups.insert(.chest)
            case .upperBack, .midBack, .lowerBack, .lats, .traps:
                groups.insert(.back)
            case .anteriorDeltoids, .lateralDeltoids, .posteriorDeltoids:
                groups.insert(.shoulders)
            case .biceps:
                groups.insert(.biceps)
            case .triceps:
                groups.insert(.triceps)
            case .forearms:
                groups.insert(.forearms)
            case .upperAbs, .lowerAbs, .obliques:
                groups.insert(.abs)
            case .quads:
                groups.insert(.quads)
            case .hamstrings:
                groups.insert(.hamstrings)
            case .glutes:
                groups.insert(.glutes)
            case .calves:
                groups.insert(.calves)
            }
        }
        
        return Array(groups)
    }
}

#Preview {
    AddExerciseView(workout: .constant(Workout(name: "Test")))
        .environmentObject(WorkoutDataStore())
}
