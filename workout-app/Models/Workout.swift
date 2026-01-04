import Foundation
import SwiftUI

struct Workout: Identifiable, Codable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]
    
    init(name: String, exercises: [Exercise] = []) {
        self.name = name
        self.exercises = exercises
    }
}

struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var muscleGroups: [MuscleGroup]
    
    init(name: String, muscleGroups: [MuscleGroup]) {
        self.name = name
        self.muscleGroups = muscleGroups
    }
}

enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"
    case abs = "Abs"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    
    var color: Color {
        switch self {
        case .chest: return .red
        case .back: return .blue
        case .shoulders: return .green
        case .biceps: return .orange
        case .triceps: return .purple
        case .forearms: return .yellow
        case .abs: return .pink
        case .quads: return .cyan
        case .hamstrings: return .brown
        case .glutes: return .indigo
        case .calves: return .teal
        }
    }
}

struct WorkoutLog: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var exerciseId: UUID
    var exerciseName: String
    var sets: Int
    var reps: Int
    var weight: Double
    
    init(date: Date = Date(), exerciseId: UUID, exerciseName: String, sets: Int, reps: Int, weight: Double) {
        self.date = date
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}

