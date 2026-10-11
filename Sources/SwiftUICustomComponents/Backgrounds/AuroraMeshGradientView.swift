import SwiftUI

/// An animated fluid aurora gradient background that smoothly shifts and morphs in the background of screens.
public struct AuroraMeshGradientView: View {
    public var baseColor: Color
    
    @State private var phase: Double = 0
    @State private var hueShift: Double = 0
    
    public init(baseColor: Color = Color(red: 0.05, green: 0.03, blue: 0.10)) {
        self.baseColor = baseColor
    }
    
    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let date = timeline.date.timeIntervalSinceReferenceDate
            let angle1 = date * 0.4
            let angle2 = date * 0.6
            
            ZStack {
                baseColor.ignoresSafeArea()
                
                // Pulsing Aurora Orb 1
                RadialGradient(
                    colors: [
                        Color(red: 0.55, green: 0.25, blue: 0.95).opacity(0.45),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.3 + sin(angle1) * 0.2, y: 0.3 + cos(angle1) * 0.2),
                    startRadius: 20,
                    endRadius: 280
                )
                .blur(radius: 40)
                
                // Pulsing Aurora Orb 2
                RadialGradient(
                    colors: [
                        Color(red: 0.15, green: 0.75, blue: 0.95).opacity(0.4),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.7 - cos(angle2) * 0.25, y: 0.6 + sin(angle2) * 0.2),
                    startRadius: 30,
                    endRadius: 320
                )
                .blur(radius: 50)
                
                // Pulsing Aurora Orb 3 (Accent Pink/Amber)
                RadialGradient(
                    colors: [
                        Color(red: 0.95, green: 0.35, blue: 0.65).opacity(0.35),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.5 + cos(angle1 * 0.7) * 0.3, y: 0.8 - sin(angle2 * 0.5) * 0.2),
                    startRadius: 20,
                    endRadius: 260
                )
                .blur(radius: 45)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    AuroraMeshGradientView()
}
