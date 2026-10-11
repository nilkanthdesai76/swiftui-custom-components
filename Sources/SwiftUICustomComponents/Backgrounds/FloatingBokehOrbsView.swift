import SwiftUI

private struct BokehOrb: Identifiable {
    let id = UUID()
    var xRatio: CGFloat
    var yRatio: CGFloat
    var radius: CGFloat
    var color: Color
    var speed: Double
}

/// A serene animated background displaying floating, softly blurred bokeh orbs drifting gently.
public struct FloatingBokehOrbsView: View {
    public var baseColor: Color
    
    private let orbs: [BokehOrb] = [
        BokehOrb(xRatio: 0.2, yRatio: 0.3, radius: 140, color: Color(red: 0.35, green: 0.65, blue: 0.98).opacity(0.35), speed: 0.5),
        BokehOrb(xRatio: 0.8, yRatio: 0.2, radius: 180, color: Color(red: 0.85, green: 0.35, blue: 0.75).opacity(0.30), speed: 0.7),
        BokehOrb(xRatio: 0.5, yRatio: 0.7, radius: 160, color: Color(red: 0.20, green: 0.85, blue: 0.65).opacity(0.25), speed: 0.4),
        BokehOrb(xRatio: 0.85, yRatio: 0.85, radius: 130, color: Color(red: 0.95, green: 0.65, blue: 0.25).opacity(0.28), speed: 0.6)
    ]
    
    public init(baseColor: Color = Color(red: 0.04, green: 0.04, blue: 0.08)) {
        self.baseColor = baseColor
    }
    
    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            GeometryReader { geo in
                ZStack {
                    baseColor.ignoresSafeArea()
                    
                    ForEach(orbs) { orb in
                        let offsetX = sin(time * orb.speed) * 30
                        let offsetY = cos(time * orb.speed * 0.8) * 35
                        let posX = (geo.size.width * orb.xRatio) + offsetX
                        let posY = (geo.size.height * orb.yRatio) + offsetY
                        
                        Circle()
                            .fill(orb.color)
                            .frame(width: orb.radius * 2, height: orb.radius * 2)
                            .position(x: posX, y: posY)
                            .blur(radius: 50)
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    FloatingBokehOrbsView()
}
