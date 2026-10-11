import SwiftUI

/// A button that magnetically attracts and follows the user's finger drag with physical spring tension, snapping back with haptic feedback upon release.
public struct MagneticSpringButton: View {
    public let title: String
    public let icon: String
    public var accentColor: Color
    public var action: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isPressing: Bool = false
    
    public init(
        title: String,
        icon: String = "cursorarrow.rays",
        accentColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.accentColor = accentColor
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .scaleEffect(isPressing ? 1.2 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressing)
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            }
        )
        .shadow(color: accentColor.opacity(0.35), radius: 10, y: 5)
        .offset(dragOffset)
        .scaleEffect(isPressing ? 0.96 : 1.0)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    if !isPressing {
                        isPressing = true
                        HapticFeedback.light()
                    }
                    // Apply magnetic damping resistance so it doesn't wander too far
                    let resistance: CGFloat = 0.35
                    dragOffset = CGSize(
                        width: gesture.translation.width * resistance,
                        height: gesture.translation.height * resistance
                    )
                }
                .onEnded { gesture in
                    let distance = hypot(gesture.translation.width, gesture.translation.height)
                    if distance < 30 {
                        HapticFeedback.medium()
                        action()
                    } else {
                        HapticFeedback.selection()
                    }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        dragOffset = .zero
                        isPressing = false
                    }
                }
        )
    }
}

#Preview {
    MagneticSpringButton(title: "Magnetic Fluid Press", icon: "magnet.fill") {}
}
