import SwiftUI

/// A toggle switch featuring viscous liquid stretching where the thumb stretches horizontally during state transitions.
public struct LiquidStretchSwitch: View {
    @Binding public var isOn: Bool
    public var onColor: Color
    public var offColor: Color
    
    @State private var isAnimating: Bool = false
    
    public init(
        isOn: Binding<Bool>,
        onColor: Color = .blue,
        offColor: Color = Color.primary.opacity(0.12)
    ) {
        self._isOn = isOn
        self.onColor = onColor
        self.offColor = offColor
    }
    
    public var body: some View {
        Button {
            HapticFeedback.selection()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                isAnimating = true
            }
            withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) {
                isOn.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    isAnimating = false
                }
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                // Background Track
                Capsule()
                    .fill(isOn ? onColor : offColor)
                    .frame(width: 62, height: 34)
                
                // Stretchy Liquid Thumb
                Capsule()
                    .fill(Color.white)
                    .frame(width: isAnimating ? 38 : 26, height: 26)
                    .shadow(color: Color.black.opacity(0.18), radius: 4, y: 1)
                    .padding(4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LiquidStretchSwitch(isOn: .constant(true))
        .padding()
}
