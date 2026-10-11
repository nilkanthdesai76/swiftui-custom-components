import SwiftUI

/// An interactive slider with an elastic floating tooltip bubble that expands and follows the user's thumb during drag.
public struct ElasticBubbleSlider: View {
    @Binding public var value: Double
    public var range: ClosedRange<Double>
    public var tintColor: Color
    public var valueFormatter: (Double) -> String
    
    @State private var isDragging: Bool = false
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        tintColor: Color = .blue,
        valueFormatter: @escaping (Double) -> String = { "\(Int($0))%" }
    ) {
        self._value = value
        self.range = range
        self.tintColor = tintColor
        self.valueFormatter = valueFormatter
    }
    
    public var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - 28
            let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let thumbX = 14 + (trackWidth * CGFloat(percentage))
            
            ZStack(alignment: .leading) {
                // Background Track
                Capsule()
                    .fill(Color.primary.opacity(0.08))
                    .frame(height: 8)
                
                // Active Track
                Capsule()
                    .fill(tintColor)
                    .frame(width: max(thumbX, 14), height: 8)
                
                // Floating Bubble Tooltip
                if isDragging {
                    VStack(spacing: 0) {
                        Text(valueFormatter(value))
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(tintColor)
                                    .shadow(color: tintColor.opacity(0.4), radius: 6, y: 3)
                            )
                        
                        // Bubble pointer tip
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 7))
                            .foregroundColor(tintColor)
                            .offset(y: -1)
                    }
                    .position(x: thumbX, y: -24)
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(tintColor, lineWidth: isDragging ? 3 : 2))
                    .shadow(color: Color.black.opacity(0.15), radius: 6, y: 2)
                    .scaleEffect(isDragging ? 1.15 : 1.0)
                    .position(x: thumbX, y: geo.size.height / 2)
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        if !isDragging {
                            HapticFeedback.light()
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                isDragging = true
                            }
                        }
                        
                        let relativeX = min(max(val.location.x - 14, 0), trackWidth)
                        let newFraction = Double(relativeX / trackWidth)
                        let newValue = range.lowerBound + newFraction * (range.upperBound - range.lowerBound)
                        self.value = newValue
                    }
                    .onEnded { _ in
                        HapticFeedback.light()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            isDragging = false
                        }
                    }
            )
        }
        .frame(height: 60)
    }
}

#Preview {
    ElasticBubbleSlider(value: .constant(65))
        .padding()
}
