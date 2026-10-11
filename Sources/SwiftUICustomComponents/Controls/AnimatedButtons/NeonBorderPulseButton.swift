import SwiftUI
import Combine

public struct NeonBorderPulseButton: View {
    public var title: String
    public var icon: String?
    public var neonColor: Color
    public var action: () -> Void
    
    @State private var rotation: Double = 0
    @State private var isPressed: Bool = false
    
    public init(
        title: String,
        icon: String? = nil,
        neonColor: Color = .cyan,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.neonColor = neonColor
        self.action = action
    }
    
    public var body: some View {
        Button {
            HapticFeedback.medium()
            action()
        } label: {
            ZStack {
                // Neon Rotating Border Beam
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                neonColor.opacity(0.05),
                                neonColor.opacity(0.1),
                                neonColor,
                                neonColor.opacity(0.1),
                                neonColor.opacity(0.05)
                            ]),
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: 2
                    )
                    .blur(radius: 2)
                
                // Crisp Border
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                neonColor.opacity(0.1),
                                neonColor,
                                neonColor.opacity(0.1)
                            ]),
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: 1.5
                    )
                
                // Dark Frosted Fill
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.75))
                    .padding(1.5)
                
                // Label & Icon
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(neonColor)
                    }
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
            }
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .shadow(color: neonColor.opacity(0.3), radius: 12)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
