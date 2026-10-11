import SwiftUI

/// An animated perspective cyberpunk synthwave grid background with moving neon scanlines and horizon glow bloom.
public struct CyberGridMatrixView: View {
    public var baseColor: Color
    public var gridColor: Color
    public var speed: Double
    
    public init(
        baseColor: Color = Color(red: 0.03, green: 0.02, blue: 0.07),
        gridColor: Color = Color(red: 0.75, green: 0.20, blue: 0.95),
        speed: Double = 1.0
    ) {
        self.baseColor = baseColor
        self.gridColor = gridColor
        self.speed = speed
    }
    
    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * speed
            
            GeometryReader { geo in
                ZStack {
                    baseColor.ignoresSafeArea()
                    
                    // Horizon Glow Bloom
                    RadialGradient(
                        colors: [
                            gridColor.opacity(0.4),
                            Color.cyan.opacity(0.2),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.5, y: 0.45),
                        startRadius: 10,
                        endRadius: 260
                    )
                    .blur(radius: 30)
                    .ignoresSafeArea()
                    
                    Canvas { context, size in
                        let horizonY = size.height * 0.45
                        let gridOffset = CGFloat(time.truncatingRemainder(dividingBy: 1.0)) * 40
                        
                        // Draw Perspective Radial Lines (Vanishing point at horizon center)
                        let vanishingPoint = CGPoint(x: size.width / 2, y: horizonY)
                        let rayCount = 14
                        
                        for i in 0...rayCount {
                            let fraction = CGFloat(i) / CGFloat(rayCount)
                            let bottomX = -size.width * 0.3 + fraction * (size.width * 1.6)
                            var path = Path()
                            path.move(to: vanishingPoint)
                            path.addLine(to: CGPoint(x: bottomX, y: size.height))
                            
                            context.stroke(
                                path,
                                with: .color(gridColor.opacity(0.25)),
                                lineWidth: 1.2
                            )
                        }
                        
                        // Draw Horizontal Perspective Scanning Lines
                        var currentY = horizonY + 8
                        var step: CGFloat = 8
                        var index = 0
                        
                        while currentY < size.height + 40 {
                            let animatedY = currentY + (gridOffset * (step / 35))
                            if animatedY >= horizonY && animatedY <= size.height {
                                var hLine = Path()
                                hLine.move(to: CGPoint(x: 0, y: animatedY))
                                hLine.addLine(to: CGPoint(x: size.width, y: animatedY))
                                
                                let fadeAlpha = Double(min(1.0, (animatedY - horizonY) / (size.height * 0.4)))
                                context.stroke(
                                    hLine,
                                    with: .color(gridColor.opacity(0.15 + fadeAlpha * 0.3)),
                                    lineWidth: 1.2
                                )
                            }
                            step *= 1.35
                            currentY += step
                            index += 1
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    CyberGridMatrixView()
}
