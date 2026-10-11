import SwiftUI

/// An eye-catching button featuring a continuous diagonal shimmer sweep and ambient pulsing glow.
public struct ShimmerPulseButton: View {
    public let title: String
    public let icon: String?
    public var gradientColors: [Color]
    public var action: () -> Void
    
    @State private var shimmerOffset: CGFloat = -1.2
    
    public init(
        title: String,
        icon: String? = nil,
        gradientColors: [Color] = [.blue, .purple],
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.gradientColors = gradientColors
        self.action = action
    }
    
    public var body: some View {
        Button {
            HapticFeedback.medium()
            action()
        } label: {
            ZStack {
                // Background Gradient
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                // Shimmer Light Sweep
                GeometryReader { geo in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.35),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(20))
                        .offset(x: geo.size.width * shimmerOffset)
                }
                .mask(RoundedRectangle(cornerRadius: 16))
                
                // Content
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                    }
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
            }
            .frame(height: 52)
            .shadow(color: gradientColors.first?.opacity(0.4) ?? .blue.opacity(0.4), radius: 10, y: 4)
        }
        .buttonStyle(ShimmerScaleButtonStyle())
        .onAppear {
            withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false)) {
                shimmerOffset = 1.4
            }
        }
    }
}

private struct ShimmerScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ShimmerPulseButton(title: "Unlock Instant Access", icon: "sparkles") {}
        .padding()
}
