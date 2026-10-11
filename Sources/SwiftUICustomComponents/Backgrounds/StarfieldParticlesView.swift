import SwiftUI

private struct StarParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var opacity: Double
    var speed: CGFloat
}

/// A 60fps canvas-rendered starfield particle background featuring drifting star dust and twinkling points.
public struct StarfieldParticlesView: View {
    public var baseColor: Color
    public var particleColor: Color
    public var particleCount: Int
    
    @State private var stars: [StarParticle] = []
    
    public init(
        baseColor: Color = Color(red: 0.03, green: 0.03, blue: 0.06),
        particleColor: Color = .white,
        particleCount: Int = 50
    ) {
        self.baseColor = baseColor
        self.particleColor = particleColor
        self.particleCount = particleCount
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(baseColor))
                
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for star in stars {
                    let yOffset = (star.y + CGFloat(time) * star.speed * 20).truncatingRemainder(dividingBy: size.height)
                    let twinkle = 0.4 + 0.6 * sin(time * 2.0 + Double(star.x))
                    
                    let rect = CGRect(
                        x: star.x,
                        y: yOffset,
                        width: star.radius * 2,
                        height: star.radius * 2
                    )
                    
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particleColor.opacity(star.opacity * twinkle))
                    )
                }
            }
            .ignoresSafeArea()
            .onAppear {
                generateStars()
            }
        }
    }
    
    private func generateStars() {
        guard stars.isEmpty else { return }
        #if canImport(UIKit)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        #else
        let screenWidth: CGFloat = 800
        let screenHeight: CGFloat = 800
        #endif
        
        var list: [StarParticle] = []
        for _ in 0..<particleCount {
            list.append(
                StarParticle(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight),
                    radius: CGFloat.random(in: 1.0...2.5),
                    opacity: Double.random(in: 0.3...0.9),
                    speed: CGFloat.random(in: 0.4...1.2)
                )
            )
        }
        stars = list
    }
}

#Preview {
    StarfieldParticlesView()
}
