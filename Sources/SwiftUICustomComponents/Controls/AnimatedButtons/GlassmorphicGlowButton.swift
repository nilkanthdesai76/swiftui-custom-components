import SwiftUI

/// An ultra-modern glassmorphic button with an illuminated neon perimeter gradient, specular refraction sheen, and spring press physics.
public struct GlassmorphicGlowButton: View {
    public let title: String
    public let icon: String
    public var glowColors: [Color]
    public var action: () -> Void
    
    @State private var isPressed: Bool = false
    
    public init(
        title: String,
        icon: String = "sparkles",
        glowColors: [Color] = [Color.purple, Color.cyan],
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.glowColors = glowColors
        self.action = action
    }
    
    public var body: some View {
        Button {
            HapticFeedback.light()
            action()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    // Ambient glow shadow
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: glowColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 12)
                        .opacity(0.4)
                    
                    // Ultra thin material glass core
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    // Gradient border highlight
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: glowColors + [glowColors.first ?? .white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GlassmorphicGlowButton(title: "Launch Hyperdrive", icon: "paperplane.fill") {}
    }
}
