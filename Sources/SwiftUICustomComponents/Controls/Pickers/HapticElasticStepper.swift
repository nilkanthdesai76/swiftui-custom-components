import SwiftUI
import Combine

public struct HapticElasticStepper: View {
    @Binding public var value: Int
    public var range: ClosedRange<Int>
    public var step: Int
    public var tintColor: Color
    
    @State private var bounceScale: CGFloat = 1.0
    
    public init(
        value: Binding<Int>,
        range: ClosedRange<Int> = 1...99,
        step: Int = 1,
        tintColor: Color = .blue
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.tintColor = tintColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Decrement Button
            Button {
                guard value - step >= range.lowerBound else {
                    HapticFeedback.warning()
                    return
                }
                HapticFeedback.light()
                triggerBounce()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                    value -= step
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(value <= range.lowerBound ? .secondary.opacity(0.4) : .primary)
                    .frame(width: 38, height: 38)
                    .background(
                        Circle().fill(Color.primary.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
            .disabled(value <= range.lowerBound)
            
            // Value Badge
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(tintColor.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(tintColor.opacity(0.3), lineWidth: 1)
                    )
                    .frame(width: 54, height: 38)
                
                Text("\(value)")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(tintColor)
                    .scaleEffect(bounceScale)
            }
            
            // Increment Button
            Button {
                guard value + step <= range.upperBound else {
                    HapticFeedback.warning()
                    return
                }
                HapticFeedback.light()
                triggerBounce()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                    value += step
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(value >= range.upperBound ? .secondary.opacity(0.4) : .primary)
                    .frame(width: 38, height: 38)
                    .background(
                        Circle().fill(Color.primary.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
            .disabled(value >= range.upperBound)
        }
        .padding(6)
        .background(
            Capsule()
                .fill(Color.primary.opacity(0.04))
        )
    }
    
    private func triggerBounce() {
        withAnimation(.easeOut(duration: 0.12)) {
            bounceScale = 1.25
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                bounceScale = 1.0
            }
        }
    }
}
