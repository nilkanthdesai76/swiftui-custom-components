import SwiftUI

private struct ParticleDot: Identifiable {
    let id = UUID()
    var x: CGFloat = 0
    var y: CGFloat = 0
    var scale: CGFloat = 1.0
    var opacity: Double = 1.0
    var color: Color
}

/// A button that emits a celebratory particle burst upon tap.
public struct ParticleBurstButton: View {
    public let title: String
    public let icon: String?
    public var tintColor: Color
    public var action: () -> Void
    
    @State private var particles: [ParticleDot] = []
    
    public init(
        title: String = "Celebrate",
        icon: String? = "sparkles",
        tintColor: Color = .pink,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.tintColor = tintColor
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            // Emitted Particles
            ForEach(particles) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(p.scale)
                    .opacity(p.opacity)
                    .offset(x: p.x, y: p.y)
            }
            
            // Primary Button
            Button {
                HapticFeedback.success()
                triggerBurst()
                action()
            } label: {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                    }
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(tintColor)
                        .shadow(color: tintColor.opacity(0.35), radius: 8, y: 4)
                )
            }
            .buttonStyle(BurstScaleButtonStyle())
        }
    }
    
    private func triggerBurst() {
        let colors: [Color] = [.pink, .purple, .yellow, .cyan, .orange, .green]
        var newParticles: [ParticleDot] = []
        
        for _ in 0..<18 {
            let angle = Double.random(in: 0...Double.pi * 2)
            let distance = CGFloat.random(in: 45...85)
            let color = colors.randomElement() ?? .pink
            
            var dot = ParticleDot(color: color)
            dot.x = cos(angle) * distance
            dot.y = sin(angle) * distance
            newParticles.append(dot)
        }
        
        particles = newParticles
        
        withAnimation(.easeOut(duration: 0.65)) {
            for i in particles.indices {
                particles[i].opacity = 0
                particles[i].scale = 0.2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            particles.removeAll()
        }
    }
}

private struct BurstScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ParticleBurstButton(title: "Like & Support", icon: "heart.fill") {}
        .padding()
}
