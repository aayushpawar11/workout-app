import Foundation
import SwiftUI
import UIKit

struct Workout: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]
    var color: Color
    
    init(name: String, exercises: [Exercise] = [], color: Color = .yellow) {
        self.name = name
        self.exercises = exercises
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, exercises, colorRed, colorGreen, colorBlue, colorAlpha
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        exercises = try container.decode([Exercise].self, forKey: .exercises)
        
        // Decode color components if available, otherwise use default
        if let red = try? container.decode(Double.self, forKey: .colorRed),
           let green = try? container.decode(Double.self, forKey: .colorGreen),
           let blue = try? container.decode(Double.self, forKey: .colorBlue),
           let alpha = try? container.decode(Double.self, forKey: .colorAlpha) {
            color = Color(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            color = .yellow
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(exercises, forKey: .exercises)
        
        // Encode color components using UIColor conversion
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            try container.encode(Double(red), forKey: .colorRed)
            try container.encode(Double(green), forKey: .colorGreen)
            try container.encode(Double(blue), forKey: .colorBlue)
            try container.encode(Double(alpha), forKey: .colorAlpha)
        } else {
            // Fallback to yellow if color conversion fails
            try container.encode(1.0, forKey: .colorRed)
            try container.encode(1.0, forKey: .colorGreen)
            try container.encode(0.0, forKey: .colorBlue)
            try container.encode(1.0, forKey: .colorAlpha)
        }
    }
}

struct Exercise: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var muscleGroups: [MuscleGroup]
    var detailedMuscles: [DetailedMuscle] // AI-determined specific muscles
    
    init(name: String, muscleGroups: [MuscleGroup], detailedMuscles: [DetailedMuscle] = []) {
        self.name = name
        self.muscleGroups = muscleGroups
        self.detailedMuscles = detailedMuscles
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, muscleGroups, detailedMuscles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        muscleGroups = try container.decode([MuscleGroup].self, forKey: .muscleGroups)
        // Handle missing detailedMuscles field for backward compatibility
        detailedMuscles = (try? container.decode([DetailedMuscle].self, forKey: .detailedMuscles)) ?? []
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

// Detailed muscle regions for precise highlighting
enum DetailedMuscle: String, Codable, CaseIterable {
    // Chest regions
    case upperChest = "Upper Chest"
    case midChest = "Mid Chest"
    case lowerChest = "Lower Chest"
    
    // Back regions
    case upperBack = "Upper Back"
    case midBack = "Mid Back"
    case lowerBack = "Lower Back"
    case lats = "Lats"
    case traps = "Traps"
    
    // Shoulder regions
    case anteriorDeltoids = "Anterior Deltoids"
    case lateralDeltoids = "Lateral Deltoids"
    case posteriorDeltoids = "Posterior Deltoids"
    
    // Arms
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"
    
    // Core
    case upperAbs = "Upper Abs"
    case lowerAbs = "Lower Abs"
    case obliques = "Obliques"
    
    // Legs
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    
    var color: Color {
        switch self {
        case .upperChest, .midChest, .lowerChest: return .red
        case .upperBack, .midBack, .lowerBack, .lats, .traps: return .blue
        case .anteriorDeltoids, .lateralDeltoids, .posteriorDeltoids: return .green
        case .biceps: return .orange
        case .triceps: return .purple
        case .forearms: return .yellow
        case .upperAbs, .lowerAbs, .obliques: return .pink
        case .quads: return .cyan
        case .hamstrings: return .brown
        case .glutes: return .indigo
        case .calves: return .teal
        }
    }
    
    var isFrontView: Bool {
        switch self {
        case .upperChest, .midChest, .lowerChest, .anteriorDeltoids, .lateralDeltoids, .biceps, .forearms, .upperAbs, .lowerAbs, .obliques, .quads, .calves:
            return true
        case .upperBack, .midBack, .lowerBack, .lats, .traps, .posteriorDeltoids, .triceps, .hamstrings, .glutes:
            return false
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

