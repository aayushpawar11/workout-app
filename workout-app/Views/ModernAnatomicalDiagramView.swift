import SwiftUI

struct ModernAnatomicalDiagramView: View {
    let activeMuscles: Set<DetailedMuscle>
    let isFront: Bool
    let highlightColor: Color
    
    private var bodyImageName: String {
        isFront ? "anatomical_body_front" : "anatomical_body_back"
    }
    
    private var musclesForView: [DetailedMuscle] {
        activeMuscles.filter { $0.isFrontView == isFront }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base anatomical body image
                Image(bodyImageName)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        // Overlay colored highlights that blend with the image
                        ZStack {
                            ForEach(musclesForView, id: \.self) { muscle in
                                MusclePathView(muscle: muscle)
                                    .fill(highlightColor.opacity(0.7))
                            }
                        }
                        .blendMode(.overlay)
                    )
                    .overlay(
                        // Add bright highlights on top
                        ZStack {
                            ForEach(musclesForView, id: \.self) { muscle in
                                MusclePathView(muscle: muscle)
                                    .fill(highlightColor.opacity(0.4))
                            }
                        }
                        .blendMode(.screen)
                    )
            }
        }
    }
}
