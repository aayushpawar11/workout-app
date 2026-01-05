import SwiftUI

struct VectorAnatomicalDiagramView: View {
    let activeMuscles: Set<DetailedMuscle>
    let isFront: Bool
    let highlightColor: Color
    @State private var tappedMuscles: Set<DetailedMuscle> = []
    
    var body: some View {
        ZStack {
            // Base body outline - always visible
            baseBodyImage
            
            // Layer each muscle group
            ForEach(musclesForView, id: \.self) { muscle in
                muscleImage(for: muscle)
                    .onTapGesture {
                        handleMuscleTap(muscle)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear) // Ensure the view takes up space
    }
    
    private var musclesForView: [DetailedMuscle] {
        DetailedMuscle.allCases.filter { $0.isFrontView == isFront }
    }
    
    private var baseBodyImage: some View {
        // Base body outline - will use vector image when available
        // For now, fallback to shape-based outline
        Group {
            if let imageName = baseImageName,
               UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white.opacity(0.3))
            } else {
                // Fallback to shape-based outline - make it more visible
                AnatomicalOutline(isFront: isFront)
                    .stroke(Color.white.opacity(0.4), lineWidth: 2.5)
            }
        }
    }
    
    private var baseImageName: String? {
        isFront ? "body_base_front" : "body_base_back"
    }
    
    @ViewBuilder
    private func muscleImage(for muscle: DetailedMuscle) -> some View {
        let imageName = muscle.imageAssetName(isFront: isFront)
        let isActive = activeMuscles.contains(muscle) || tappedMuscles.contains(muscle)
        
        // Check if vector image exists
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? highlightColor : .clear)
        } else {
            // Fallback: use shape-based muscle path from PreciseMuscleHighlightView
            // Always render the shape, but make inactive ones very faint
            MusclePathView(muscle: muscle)
                .fill(isActive ? highlightColor.opacity(0.6) : Color.white.opacity(0.05))
                .overlay(
                    MusclePathView(muscle: muscle)
                        .stroke(isActive ? highlightColor : Color.white.opacity(0.1), lineWidth: isActive ? 2 : 1)
                )
        }
    }
    
    private func muscleColor(for muscle: DetailedMuscle) -> Color {
        let isActive = activeMuscles.contains(muscle) || tappedMuscles.contains(muscle)
        return isActive ? highlightColor : .clear
    }
    
    private func handleMuscleTap(_ muscle: DetailedMuscle) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if tappedMuscles.contains(muscle) {
                tappedMuscles.remove(muscle)
            } else {
                tappedMuscles.insert(muscle)
            }
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// Extension to get image asset names for muscles
extension DetailedMuscle {
    func imageAssetName(isFront: Bool) -> String {
        let viewPrefix = isFront ? "front" : "back"
        
        switch self {
        // Chest
        case .upperChest: return "chest_upper_\(viewPrefix)"
        case .midChest: return "chest_mid_\(viewPrefix)"
        case .lowerChest: return "chest_lower_\(viewPrefix)"
        
        // Back
        case .upperBack: return "back_upper_\(viewPrefix)"
        case .midBack: return "back_mid_\(viewPrefix)"
        case .lowerBack: return "back_lower_\(viewPrefix)"
        case .lats: return "lats_\(viewPrefix)"
        case .traps: return "traps_\(viewPrefix)"
        
        // Shoulders
        case .anteriorDeltoids: return "deltoids_anterior_\(viewPrefix)"
        case .lateralDeltoids: return "deltoids_lateral_\(viewPrefix)"
        case .posteriorDeltoids: return "deltoids_posterior_\(viewPrefix)"
        
        // Arms
        case .biceps: return "biceps_\(viewPrefix)"
        case .triceps: return "triceps_\(viewPrefix)"
        case .forearms: return "forearms_\(viewPrefix)"
        
        // Core
        case .upperAbs: return "abs_upper_\(viewPrefix)"
        case .lowerAbs: return "abs_lower_\(viewPrefix)"
        case .obliques: return "obliques_\(viewPrefix)"
        
        // Legs
        case .quads: return "quads_\(viewPrefix)"
        case .hamstrings: return "hamstrings_\(viewPrefix)"
        case .glutes: return "glutes_\(viewPrefix)"
        case .calves: return "calves_\(viewPrefix)"
        }
    }
}

// AnatomicalOutline is defined in AnatomicalDiagramView.swift and reused here

// Helper extension for Set to toggle items
extension Set {
    mutating func toggle(_ member: Element) {
        if contains(member) {
            remove(member)
        } else {
            insert(member)
        }
    }
}

