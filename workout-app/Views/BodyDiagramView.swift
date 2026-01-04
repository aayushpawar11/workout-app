import SwiftUI

struct BodyDiagramView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    
    var targetedMuscleGroups: Set<MuscleGroup> {
        Set(workout.exercises.flatMap { $0.muscleGroups })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(workout.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Front View
                    VStack {
                        Text("FRONT VIEW")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        ZStack {
                            BodyFrontView()
                            MuscleOverlayView(muscleGroups: targetedMuscleGroups, isFront: true)
                        }
                        .frame(height: 400)
                    }
                    
                    // Back View
                    VStack {
                        Text("BACK VIEW")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        ZStack {
                            BodyBackView()
                            MuscleOverlayView(muscleGroups: targetedMuscleGroups, isFront: false)
                        }
                        .frame(height: 400)
                    }
                    
                    // Legend
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Targeted Muscles")
                            .font(.headline)
                            .padding(.top)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                            ForEach(Array(targetedMuscleGroups), id: \.self) { group in
                                HStack {
                                    Circle()
                                        .fill(group.color)
                                        .frame(width: 20, height: 20)
                                    Text(group.rawValue)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Body Diagram")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BodyFrontView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Head
                path.addEllipse(in: CGRect(x: width * 0.35, y: height * 0.05, width: width * 0.3, height: height * 0.12))
                
                // Neck
                path.move(to: CGPoint(x: width * 0.42, y: height * 0.17))
                path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.22))
                path.move(to: CGPoint(x: width * 0.58, y: height * 0.17))
                path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.22))
                
                // Shoulders
                path.move(to: CGPoint(x: width * 0.3, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.25))
                
                // Arms
                path.move(to: CGPoint(x: width * 0.3, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.45))
                path.addLine(to: CGPoint(x: width * 0.18, y: height * 0.65))
                
                path.move(to: CGPoint(x: width * 0.7, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.45))
                path.addLine(to: CGPoint(x: width * 0.82, y: height * 0.65))
                
                // Torso
                path.move(to: CGPoint(x: width * 0.35, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.25))
                path.closeSubpath()
                
                // Legs
                path.move(to: CGPoint(x: width * 0.4, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.95))
                
                path.move(to: CGPoint(x: width * 0.6, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.95))
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
}

struct BodyBackView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Head (back)
                path.addEllipse(in: CGRect(x: width * 0.35, y: height * 0.05, width: width * 0.3, height: height * 0.12))
                
                // Neck
                path.move(to: CGPoint(x: width * 0.42, y: height * 0.17))
                path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.22))
                path.move(to: CGPoint(x: width * 0.58, y: height * 0.17))
                path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.22))
                
                // Shoulders
                path.move(to: CGPoint(x: width * 0.3, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.25))
                
                // Arms (back)
                path.move(to: CGPoint(x: width * 0.3, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.45))
                path.addLine(to: CGPoint(x: width * 0.18, y: height * 0.65))
                
                path.move(to: CGPoint(x: width * 0.7, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.45))
                path.addLine(to: CGPoint(x: width * 0.82, y: height * 0.65))
                
                // Torso (back)
                path.move(to: CGPoint(x: width * 0.35, y: height * 0.25))
                path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.25))
                path.closeSubpath()
                
                // Legs (back)
                path.move(to: CGPoint(x: width * 0.4, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.95))
                
                path.move(to: CGPoint(x: width * 0.6, y: height * 0.6))
                path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.95))
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
}

struct MuscleOverlayView: View {
    let muscleGroups: Set<MuscleGroup>
    let isFront: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isFront {
                    // Front muscle groups
                    if muscleGroups.contains(.chest) {
                        Rectangle()
                            .fill(Color.red.opacity(0.4))
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.35)
                    }
                    if muscleGroups.contains(.shoulders) {
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                            .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.28)
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                            .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.28)
                    }
                    if muscleGroups.contains(.biceps) {
                        Rectangle()
                            .fill(Color.orange.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.45)
                        Rectangle()
                            .fill(Color.orange.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.45)
                    }
                    if muscleGroups.contains(.triceps) {
                        Rectangle()
                            .fill(Color.purple.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.5)
                        Rectangle()
                            .fill(Color.purple.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.5)
                    }
                    if muscleGroups.contains(.abs) {
                        Rectangle()
                            .fill(Color.pink.opacity(0.4))
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                    }
                    if muscleGroups.contains(.quads) {
                        Rectangle()
                            .fill(Color.cyan.opacity(0.4))
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width * 0.4, y: geometry.size.height * 0.75)
                        Rectangle()
                            .fill(Color.cyan.opacity(0.4))
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width * 0.6, y: geometry.size.height * 0.75)
                    }
                    if muscleGroups.contains(.calves) {
                        Rectangle()
                            .fill(Color.teal.opacity(0.4))
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.38, y: geometry.size.height * 0.9)
                        Rectangle()
                            .fill(Color.teal.opacity(0.4))
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.62, y: geometry.size.height * 0.9)
                    }
                } else {
                    // Back muscle groups
                    if muscleGroups.contains(.back) {
                        Rectangle()
                            .fill(Color.blue.opacity(0.4))
                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.3)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.4)
                    }
                    if muscleGroups.contains(.shoulders) {
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                            .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.28)
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                            .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.28)
                    }
                    if muscleGroups.contains(.triceps) {
                        Rectangle()
                            .fill(Color.purple.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.5)
                        Rectangle()
                            .fill(Color.purple.opacity(0.4))
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.5)
                    }
                    if muscleGroups.contains(.hamstrings) {
                        Rectangle()
                            .fill(Color.brown.opacity(0.4))
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width * 0.4, y: geometry.size.height * 0.75)
                        Rectangle()
                            .fill(Color.brown.opacity(0.4))
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width * 0.6, y: geometry.size.height * 0.75)
                    }
                    if muscleGroups.contains(.glutes) {
                        Rectangle()
                            .fill(Color.indigo.opacity(0.4))
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.6)
                    }
                    if muscleGroups.contains(.calves) {
                        Rectangle()
                            .fill(Color.teal.opacity(0.4))
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.38, y: geometry.size.height * 0.9)
                        Rectangle()
                            .fill(Color.teal.opacity(0.4))
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.15)
                            .position(x: geometry.size.width * 0.62, y: geometry.size.height * 0.9)
                    }
                }
            }
        }
    }
}

#Preview {
    BodyDiagramView(workout: Workout(name: "Upper Day 1", exercises: [
        Exercise(name: "Bench Press", muscleGroups: [.chest, .triceps, .shoulders])
    ]))
}

