import SwiftUI
import Combine

public struct GlowToggleSwitch: View {
    @Binding public var isOn: Bool
    public var glowColor: Color
    public var onIcon: String
    public var offIcon: String
    
    public init(
        isOn: Binding<Bool>,
        glowColor: Color = .green,
        onIcon: String = "bolt.fill",
        offIcon: String = "power"
    ) {
        self._isOn = isOn
        self.glowColor = glowColor
        self.onIcon = onIcon
        self.offIcon = offIcon
    }
    
    public var body: some View {
        Button {
            HapticFeedback.light()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                // Background Track
                Capsule()
                    .fill(isOn ? glowColor.opacity(0.2) : Color.primary.opacity(0.08))
                    .frame(width: 64, height: 36)
                    .overlay(
                        Capsule()
                            .stroke(isOn ? glowColor.opacity(0.5) : Color.primary.opacity(0.15), lineWidth: 1.5)
                    )
                    .shadow(color: isOn ? glowColor.opacity(0.4) : Color.clear, radius: 8)
                
                // Floating Neon Thumb
                Circle()
                    .fill(isOn ? glowColor : Color.gray.opacity(0.6))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: isOn ? onIcon : offIcon)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: isOn ? glowColor.opacity(0.6) : Color.black.opacity(0.2), radius: 6)
                    .padding(4)
            }
        }
        .buttonStyle(.plain)
    }
}
