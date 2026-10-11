import SwiftUI
import Combine

public struct InteractiveTiltCard<Content: View>: View {
    public var maxAngle: Double
    public var content: () -> Content
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    public init(maxAngle: Double = 14, @ViewBuilder content: @escaping () -> Content) {
        self.maxAngle = maxAngle
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            let xNorm = dragOffset.width / (width / 2)
            let yNorm = dragOffset.height / (height / 2)
            
            let xAngle = Double(-yNorm) * maxAngle
            let yAngle = Double(xNorm) * maxAngle
            
            ZStack {
                content()
                    .overlay(
                        // Dynamic Specular Glare
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(isDragging ? 0.25 : 0.0),
                                        Color.clear
                                    ]),
                                    startPoint: UnitPoint(
                                        x: 0.5 + Double(xNorm * 0.4),
                                        y: 0.5 + Double(yNorm * 0.4)
                                    ),
                                    endPoint: UnitPoint(
                                        x: 0.5 - Double(xNorm * 0.4),
                                        y: 0.5 - Double(yNorm * 0.4)
                                    )
                                )
                            )
                            .blendMode(.overlay)
                    )
            }
            .rotation3DEffect(
                .degrees(isDragging ? xAngle : 0),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.7
            )
            .rotation3DEffect(
                .degrees(isDragging ? yAngle : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.7
            )
            .scaleEffect(isDragging ? 1.03 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: dragOffset)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isDragging)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            HapticFeedback.light()
                        }
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        dragOffset = .zero
                        HapticFeedback.light()
                    }
            )
        }
    }
}
