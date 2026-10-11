import SwiftUI
import Combine

public struct CircularDialSlider: View {
    @Binding public var value: Double
    public var range: ClosedRange<Double>
    public var title: String
    public var unit: String
    public var tintColor: Color
    
    private let totalAngle: Double = 260
    private let startAngle: Double = 140
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        title: String = "Volume",
        unit: String = "%",
        tintColor: Color = .blue
    ) {
        self._value = value
        self.range = range
        self.title = title
        self.unit = unit
        self.tintColor = tintColor
    }
    
    private var normalizedProgress: Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return max(0, min(1, (value - range.lowerBound) / span))
    }
    
    public var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let strokeWidth: CGFloat = 14
            
            ZStack {
                // Background Inactive Arc
                Circle()
                    .trim(from: 0, to: CGFloat(totalAngle / 360))
                    .stroke(
                        Color.gray.opacity(0.2),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(startAngle))
                    .frame(width: size - strokeWidth, height: size - strokeWidth)
                
                // Active Glowing Progress Arc
                Circle()
                    .trim(from: 0, to: CGFloat((totalAngle * normalizedProgress) / 360))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [tintColor.opacity(0.6), tintColor]),
                            center: .center,
                            startAngle: .degrees(startAngle),
                            endAngle: .degrees(startAngle + totalAngle)
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(startAngle))
                    .frame(width: size - strokeWidth, height: size - strokeWidth)
                    .shadow(color: tintColor.opacity(0.4), radius: 8)
                
                // Thumb Handle
                let currentAngle = (startAngle + (totalAngle * normalizedProgress)) * .pi / 180
                let thumbRadius = (size - strokeWidth) / 2
                let thumbX = center.x + CGFloat(cos(currentAngle)) * thumbRadius
                let thumbY = center.y + CGFloat(sin(currentAngle)) * thumbRadius
                
                Circle()
                    .fill(Color.white)
                    .frame(width: strokeWidth + 8, height: strokeWidth + 8)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
                    .overlay(
                        Circle().fill(tintColor).frame(width: 8, height: 8)
                    )
                    .position(x: thumbX, y: thumbY)
                
                // Center Readout
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(value))")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text(unit)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let vector = CGVector(dx: gesture.location.x - center.x, dy: gesture.location.y - center.y)
                        var angle = atan2(vector.dy, vector.dx) * 180 / .pi
                        if angle < 0 { angle += 360 }
                        
                        // Map angle from startAngle through startAngle + totalAngle
                        var relativeAngle = angle - startAngle
                        if relativeAngle < 0 { relativeAngle += 360 }
                        
                        if relativeAngle <= totalAngle + 20 {
                            let clamped = min(totalAngle, max(0, relativeAngle))
                            let progress = clamped / totalAngle
                            let span = range.upperBound - range.lowerBound
                            let newValue = range.lowerBound + (span * progress)
                            
                            if abs(newValue - value) >= 1.0 {
                                HapticFeedback.light()
                            }
                            value = newValue
                        }
                    }
            )
        }
        .frame(width: 170, height: 170)
    }
}
