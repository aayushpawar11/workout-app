import SwiftUI

struct PreciseMuscleHighlightView: View {
    let muscles: [DetailedMuscle]
    let isFront: Bool
    
    // Calculate intensity for each muscle (how many exercises target it)
    var muscleIntensity: [DetailedMuscle: Int] {
        var intensity: [DetailedMuscle: Int] = [:]
        for muscle in muscles {
            intensity[muscle, default: 0] += 1
        }
        return intensity
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(muscleIntensity.keys).filter { $0.isFrontView == isFront }, id: \.self) { muscle in
                    let intensity = muscleIntensity[muscle] ?? 0
                    let color: Color = {
                        if intensity == 0 {
                            return .brown
                        } else if intensity == 1 {
                            return .gray
                        } else {
                            return .yellow // 2+ exercises
                        }
                    }()
                    
                    MusclePathView(muscle: muscle)
                        .fill(color.opacity(0.8))
                        .overlay(
                            MusclePathView(muscle: muscle)
                                .stroke(color, lineWidth: 1.5)
                        )
                }
            }
        }
    }
}

struct MusclePathView: Shape {
    let muscle: DetailedMuscle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        switch muscle {
        // Back View Muscles - Matching the image exactly
        case .lats:
            // Left lat - yellow when highlighted
            path.move(to: CGPoint(x: width * 0.35, y: height * 0.25))
            path.addCurve(to: CGPoint(x: width * 0.28, y: height * 0.4), 
                         control1: CGPoint(x: width * 0.32, y: height * 0.32),
                         control2: CGPoint(x: width * 0.3, y: height * 0.36))
            path.addCurve(to: CGPoint(x: width * 0.32, y: height * 0.52), 
                         control1: CGPoint(x: width * 0.29, y: height * 0.46),
                         control2: CGPoint(x: width * 0.305, y: height * 0.49))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.25))
            path.closeSubpath()
            
            // Right lat
            path.move(to: CGPoint(x: width * 0.65, y: height * 0.25))
            path.addCurve(to: CGPoint(x: width * 0.72, y: height * 0.4), 
                         control1: CGPoint(x: width * 0.68, y: height * 0.32),
                         control2: CGPoint(x: width * 0.7, y: height * 0.36))
            path.addCurve(to: CGPoint(x: width * 0.68, y: height * 0.52), 
                         control1: CGPoint(x: width * 0.71, y: height * 0.46),
                         control2: CGPoint(x: width * 0.695, y: height * 0.49))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.25))
            path.closeSubpath()
            
        case .traps:
            // Traps - yellow when highlighted (upper back diamond shape)
            path.move(to: CGPoint(x: width * 0.3, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.22), 
                         control1: CGPoint(x: width * 0.38, y: height * 0.2),
                         control2: CGPoint(x: width * 0.44, y: height * 0.21))
            path.addCurve(to: CGPoint(x: width * 0.7, y: height * 0.19), 
                         control1: CGPoint(x: width * 0.56, y: height * 0.21),
                         control2: CGPoint(x: width * 0.62, y: height * 0.2))
            path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.25), 
                         control1: CGPoint(x: width * 0.6, y: height * 0.22),
                         control2: CGPoint(x: width * 0.55, y: height * 0.24))
            path.addCurve(to: CGPoint(x: width * 0.3, y: height * 0.19), 
                         control1: CGPoint(x: width * 0.45, y: height * 0.24),
                         control2: CGPoint(x: width * 0.4, y: height * 0.22))
            path.closeSubpath()
            
        case .upperBack:
            // Upper back center - yellow when highlighted
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.25))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.25))
            path.closeSubpath()
            
        case .midBack:
            // Mid back - yellow when highlighted
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.35))
            path.closeSubpath()
            
        case .lowerBack:
            // Lower back - yellow when highlighted
            path.move(to: CGPoint(x: width * 0.42, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.58))
            path.addLine(to: CGPoint(x: width * 0.46, y: height * 0.58))
            path.addLine(to: CGPoint(x: width * 0.46, y: height * 0.5))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.54, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.54, y: height * 0.58))
            path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.58))
            path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.5))
            path.closeSubpath()
            
        case .posteriorDeltoids:
            // Posterior deltoids - gray when highlighted
            path.move(to: CGPoint(x: width * 0.28, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.18, y: height * 0.35), 
                         control1: CGPoint(x: width * 0.23, y: height * 0.25),
                         control2: CGPoint(x: width * 0.2, y: height * 0.3))
            path.addCurve(to: CGPoint(x: width * 0.25, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.21, y: height * 0.33),
                         control2: CGPoint(x: width * 0.23, y: height * 0.325))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.72, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.82, y: height * 0.35), 
                         control1: CGPoint(x: width * 0.77, y: height * 0.25),
                         control2: CGPoint(x: width * 0.8, y: height * 0.3))
            path.addCurve(to: CGPoint(x: width * 0.75, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.79, y: height * 0.33),
                         control2: CGPoint(x: width * 0.77, y: height * 0.325))
            path.closeSubpath()
            
        case .triceps:
            // Triceps - brown when highlighted
            path.move(to: CGPoint(x: width * 0.18, y: height * 0.35))
            path.addCurve(to: CGPoint(x: width * 0.15, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.16, y: height * 0.42),
                         control2: CGPoint(x: width * 0.155, y: height * 0.46))
            path.addCurve(to: CGPoint(x: width * 0.18, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.155, y: height * 0.56),
                         control2: CGPoint(x: width * 0.16, y: height * 0.6))
            path.addCurve(to: CGPoint(x: width * 0.2, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.19, y: height * 0.6),
                         control2: CGPoint(x: width * 0.195, y: height * 0.56))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.82, y: height * 0.35))
            path.addCurve(to: CGPoint(x: width * 0.85, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.84, y: height * 0.42),
                         control2: CGPoint(x: width * 0.845, y: height * 0.46))
            path.addCurve(to: CGPoint(x: width * 0.82, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.845, y: height * 0.56),
                         control2: CGPoint(x: width * 0.84, y: height * 0.6))
            path.addCurve(to: CGPoint(x: width * 0.8, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.81, y: height * 0.6),
                         control2: CGPoint(x: width * 0.805, y: height * 0.56))
            path.closeSubpath()
            
        case .biceps:
            // Biceps (back view shows as part of upper arm) - brown
            path.move(to: CGPoint(x: width * 0.18, y: height * 0.35))
            path.addCurve(to: CGPoint(x: width * 0.15, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.16, y: height * 0.42),
                         control2: CGPoint(x: width * 0.155, y: height * 0.46))
            path.addCurve(to: CGPoint(x: width * 0.18, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.155, y: height * 0.56),
                         control2: CGPoint(x: width * 0.16, y: height * 0.6))
            path.addCurve(to: CGPoint(x: width * 0.2, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.19, y: height * 0.6),
                         control2: CGPoint(x: width * 0.195, y: height * 0.56))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.82, y: height * 0.35))
            path.addCurve(to: CGPoint(x: width * 0.85, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.84, y: height * 0.42),
                         control2: CGPoint(x: width * 0.845, y: height * 0.46))
            path.addCurve(to: CGPoint(x: width * 0.82, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.845, y: height * 0.56),
                         control2: CGPoint(x: width * 0.84, y: height * 0.6))
            path.addCurve(to: CGPoint(x: width * 0.8, y: height * 0.5), 
                         control1: CGPoint(x: width * 0.81, y: height * 0.6),
                         control2: CGPoint(x: width * 0.805, y: height * 0.56))
            path.closeSubpath()
            
        case .forearms:
            // Forearms - gray
            path.move(to: CGPoint(x: width * 0.12, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.78))
            path.addLine(to: CGPoint(x: width * 0.14, y: height * 0.78))
            path.addLine(to: CGPoint(x: width * 0.16, y: height * 0.65))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.88, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.78))
            path.addLine(to: CGPoint(x: width * 0.86, y: height * 0.78))
            path.addLine(to: CGPoint(x: width * 0.84, y: height * 0.65))
            path.closeSubpath()
            
        case .glutes:
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.58))
            path.addCurve(to: CGPoint(x: width * 0.42, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.41, y: height * 0.61),
                         control2: CGPoint(x: width * 0.415, y: height * 0.63))
            path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.67), 
                         control1: CGPoint(x: width * 0.45, y: height * 0.66),
                         control2: CGPoint(x: width * 0.475, y: height * 0.665))
            path.addCurve(to: CGPoint(x: width * 0.58, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.525, y: height * 0.665),
                         control2: CGPoint(x: width * 0.55, y: height * 0.66))
            path.addCurve(to: CGPoint(x: width * 0.6, y: height * 0.58), 
                         control1: CGPoint(x: width * 0.585, y: height * 0.63),
                         control2: CGPoint(x: width * 0.59, y: height * 0.61))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.58))
            path.closeSubpath()
            
        case .hamstrings:
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.58))
            path.addCurve(to: CGPoint(x: width * 0.38, y: height * 0.75), 
                         control1: CGPoint(x: width * 0.39, y: height * 0.66),
                         control2: CGPoint(x: width * 0.385, y: height * 0.7))
            path.addCurve(to: CGPoint(x: width * 0.36, y: height * 0.85), 
                         control1: CGPoint(x: width * 0.37, y: height * 0.78),
                         control2: CGPoint(x: width * 0.365, y: height * 0.82))
            path.addLine(to: CGPoint(x: width * 0.32, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.36, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.85))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.58))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.6, y: height * 0.58))
            path.addCurve(to: CGPoint(x: width * 0.62, y: height * 0.75), 
                         control1: CGPoint(x: width * 0.61, y: height * 0.66),
                         control2: CGPoint(x: width * 0.615, y: height * 0.7))
            path.addCurve(to: CGPoint(x: width * 0.64, y: height * 0.85), 
                         control1: CGPoint(x: width * 0.63, y: height * 0.78),
                         control2: CGPoint(x: width * 0.635, y: height * 0.82))
            path.addLine(to: CGPoint(x: width * 0.68, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.64, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.85))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.58))
            path.closeSubpath()
            
        // Front View Muscles
        case .upperChest:
            path.move(to: CGPoint(x: width * 0.32, y: height * 0.25))
            path.addCurve(to: CGPoint(x: width * 0.38, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.34, y: height * 0.28),
                         control2: CGPoint(x: width * 0.36, y: height * 0.3))
            path.addCurve(to: CGPoint(x: width * 0.45, y: height * 0.38), 
                         control1: CGPoint(x: width * 0.4, y: height * 0.35),
                         control2: CGPoint(x: width * 0.42, y: height * 0.36))
            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.36))
            path.addCurve(to: CGPoint(x: width * 0.55, y: height * 0.38), 
                         control1: CGPoint(x: width * 0.52, y: height * 0.36),
                         control2: CGPoint(x: width * 0.53, y: height * 0.37))
            path.addCurve(to: CGPoint(x: width * 0.62, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.58, y: height * 0.36),
                         control2: CGPoint(x: width * 0.6, y: height * 0.35))
            path.addCurve(to: CGPoint(x: width * 0.68, y: height * 0.25), 
                         control1: CGPoint(x: width * 0.64, y: height * 0.3),
                         control2: CGPoint(x: width * 0.66, y: height * 0.28))
            path.addLine(to: CGPoint(x: width * 0.32, y: height * 0.25))
            path.closeSubpath()
            
        case .midChest:
            path.move(to: CGPoint(x: width * 0.45, y: height * 0.38))
            path.addLine(to: CGPoint(x: width * 0.45, y: height * 0.44))
            path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.46), 
                         control1: CGPoint(x: width * 0.47, y: height * 0.45),
                         control2: CGPoint(x: width * 0.485, y: height * 0.455))
            path.addCurve(to: CGPoint(x: width * 0.55, y: height * 0.44), 
                         control1: CGPoint(x: width * 0.515, y: height * 0.455),
                         control2: CGPoint(x: width * 0.53, y: height * 0.45))
            path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.38))
            path.closeSubpath()
            
        case .lowerChest:
            path.move(to: CGPoint(x: width * 0.45, y: height * 0.44))
            path.addLine(to: CGPoint(x: width * 0.45, y: height * 0.48))
            path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.49), 
                         control1: CGPoint(x: width * 0.47, y: height * 0.485),
                         control2: CGPoint(x: width * 0.485, y: height * 0.487))
            path.addCurve(to: CGPoint(x: width * 0.55, y: height * 0.48), 
                         control1: CGPoint(x: width * 0.515, y: height * 0.487),
                         control2: CGPoint(x: width * 0.53, y: height * 0.485))
            path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.44))
            path.closeSubpath()
            
        case .anteriorDeltoids:
            path.move(to: CGPoint(x: width * 0.28, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.32, y: height * 0.25), 
                         control1: CGPoint(x: width * 0.29, y: height * 0.22),
                         control2: CGPoint(x: width * 0.305, y: height * 0.24))
            path.addCurve(to: CGPoint(x: width * 0.28, y: height * 0.3), 
                         control1: CGPoint(x: width * 0.31, y: height * 0.27),
                         control2: CGPoint(x: width * 0.29, y: height * 0.28))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.72, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.68, y: height * 0.25), 
                         control1: CGPoint(x: width * 0.71, y: height * 0.22),
                         control2: CGPoint(x: width * 0.695, y: height * 0.24))
            path.addCurve(to: CGPoint(x: width * 0.72, y: height * 0.3), 
                         control1: CGPoint(x: width * 0.69, y: height * 0.27),
                         control2: CGPoint(x: width * 0.71, y: height * 0.28))
            path.closeSubpath()
            
        case .lateralDeltoids:
            path.move(to: CGPoint(x: width * 0.28, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.18, y: height * 0.35), 
                         control1: CGPoint(x: width * 0.22, y: height * 0.26),
                         control2: CGPoint(x: width * 0.2, y: height * 0.3))
            path.addCurve(to: CGPoint(x: width * 0.25, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.21, y: height * 0.33),
                         control2: CGPoint(x: width * 0.23, y: height * 0.325))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.72, y: height * 0.19))
            path.addCurve(to: CGPoint(x: width * 0.82, y: height * 0.35), 
                         control1: CGPoint(x: width * 0.78, y: height * 0.26),
                         control2: CGPoint(x: width * 0.8, y: height * 0.3))
            path.addCurve(to: CGPoint(x: width * 0.75, y: height * 0.32), 
                         control1: CGPoint(x: width * 0.79, y: height * 0.33),
                         control2: CGPoint(x: width * 0.77, y: height * 0.325))
            path.closeSubpath()
            
        case .upperAbs:
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.48))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.52))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.52))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.48))
            path.closeSubpath()
            
        case .lowerAbs:
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.52))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.56))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.56))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.52))
            path.closeSubpath()
            
        case .obliques:
            path.move(to: CGPoint(x: width * 0.32, y: height * 0.48))
            path.addCurve(to: CGPoint(x: width * 0.4, y: height * 0.52), 
                         control1: CGPoint(x: width * 0.35, y: height * 0.5),
                         control2: CGPoint(x: width * 0.37, y: height * 0.51))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.56))
            path.addLine(to: CGPoint(x: width * 0.32, y: height * 0.54))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.68, y: height * 0.48))
            path.addCurve(to: CGPoint(x: width * 0.6, y: height * 0.52), 
                         control1: CGPoint(x: width * 0.65, y: height * 0.5),
                         control2: CGPoint(x: width * 0.63, y: height * 0.51))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.56))
            path.addLine(to: CGPoint(x: width * 0.68, y: height * 0.54))
            path.closeSubpath()
            
        case .quads:
            path.move(to: CGPoint(x: width * 0.4, y: height * 0.56))
            path.addCurve(to: CGPoint(x: width * 0.38, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.39, y: height * 0.6),
                         control2: CGPoint(x: width * 0.385, y: height * 0.62))
            path.addCurve(to: CGPoint(x: width * 0.36, y: height * 0.75), 
                         control1: CGPoint(x: width * 0.37, y: height * 0.7),
                         control2: CGPoint(x: width * 0.365, y: height * 0.72))
            path.addCurve(to: CGPoint(x: width * 0.34, y: height * 0.85), 
                         control1: CGPoint(x: width * 0.35, y: height * 0.78),
                         control2: CGPoint(x: width * 0.345, y: height * 0.82))
            path.addLine(to: CGPoint(x: width * 0.32, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.36, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.85))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.56))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.6, y: height * 0.56))
            path.addCurve(to: CGPoint(x: width * 0.62, y: height * 0.65), 
                         control1: CGPoint(x: width * 0.61, y: height * 0.6),
                         control2: CGPoint(x: width * 0.615, y: height * 0.62))
            path.addCurve(to: CGPoint(x: width * 0.64, y: height * 0.75), 
                         control1: CGPoint(x: width * 0.63, y: height * 0.7),
                         control2: CGPoint(x: width * 0.635, y: height * 0.72))
            path.addCurve(to: CGPoint(x: width * 0.66, y: height * 0.85), 
                         control1: CGPoint(x: width * 0.65, y: height * 0.78),
                         control2: CGPoint(x: width * 0.655, y: height * 0.82))
            path.addLine(to: CGPoint(x: width * 0.68, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.64, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.85))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.75))
            path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.56))
            path.closeSubpath()
            
        case .calves:
            path.move(to: CGPoint(x: width * 0.32, y: height * 0.85))
            path.addCurve(to: CGPoint(x: width * 0.34, y: height * 0.92), 
                         control1: CGPoint(x: width * 0.33, y: height * 0.88),
                         control2: CGPoint(x: width * 0.335, y: height * 0.9))
            path.addLine(to: CGPoint(x: width * 0.32, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.36, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.36, y: height * 0.92))
            path.addLine(to: CGPoint(x: width * 0.34, y: height * 0.85))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: width * 0.68, y: height * 0.85))
            path.addCurve(to: CGPoint(x: width * 0.66, y: height * 0.92), 
                         control1: CGPoint(x: width * 0.67, y: height * 0.88),
                         control2: CGPoint(x: width * 0.665, y: height * 0.9))
            path.addLine(to: CGPoint(x: width * 0.68, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.64, y: height * 0.98))
            path.addLine(to: CGPoint(x: width * 0.64, y: height * 0.92))
            path.addLine(to: CGPoint(x: width * 0.66, y: height * 0.85))
            path.closeSubpath()
        }
        
        return path
    }
}
