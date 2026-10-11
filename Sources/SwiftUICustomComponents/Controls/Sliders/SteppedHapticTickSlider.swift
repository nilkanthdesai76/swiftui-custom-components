import SwiftUI

/// A discrete stepped slider with visual track notches and haptic clicks as each notch is traversed.
public struct SteppedHapticTickSlider: View {
    @Binding public var currentStep: Int
    public let totalSteps: Int
    public var tintColor: Color
    
    @State private var dragPositionX: CGFloat? = nil
    
    public init(
        currentStep: Binding<Int>,
        totalSteps: Int = 5,
        tintColor: Color = .indigo
    ) {
        self._currentStep = currentStep
        self.totalSteps = max(totalSteps, 2)
        self.tintColor = tintColor
    }
    
    public var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - 24
            let stepSpacing = trackWidth / CGFloat(totalSteps - 1)
            let percentage = CGFloat(currentStep) / CGFloat(totalSteps - 1)
            let thumbX = 12 + (trackWidth * percentage)
            
            ZStack(alignment: .leading) {
                // Background Track
                Capsule()
                    .fill(Color.primary.opacity(0.08))
                    .frame(height: 6)
                
                // Active Track
                Capsule()
                    .fill(tintColor)
                    .frame(width: max(thumbX, 12), height: 6)
                
                // Tick Notches
                HStack(spacing: 0) {
                    ForEach(0..<totalSteps, id: \.self) { idx in
                        Circle()
                            .fill(idx <= currentStep ? tintColor : Color.primary.opacity(0.18))
                            .frame(width: 8, height: 8)
                        
                        if idx < totalSteps - 1 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(Circle().stroke(tintColor, lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                    .position(x: thumbX, y: geo.size.height / 2)
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        let relativeX = min(max(val.location.x - 12, 0), trackWidth)
                        let rawStep = Int(round(relativeX / stepSpacing))
                        let clampedStep = min(max(rawStep, 0), totalSteps - 1)
                        
                        if clampedStep != currentStep {
                            HapticFeedback.selection()
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                currentStep = clampedStep
                            }
                        }
                    }
            )
        }
        .frame(height: 44)
    }
}

#Preview {
    SteppedHapticTickSlider(currentStep: .constant(2), totalSteps: 5)
        .padding()
}
