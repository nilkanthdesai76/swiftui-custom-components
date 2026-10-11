import SwiftUI

/// An iOS Control Center-style vertical capsule slider with tactile vertical drag physics, morphing SF Symbol audio icons, and percentage readout.
public struct VerticalCapsuleVolumeSlider: View {
    @Binding public var value: Double // 0.0 to 100.0
    public var accentColor: Color
    public var height: CGFloat
    public var width: CGFloat
    
    @State private var isDragging: Bool = false
    
    public init(
        value: Binding<Double>,
        accentColor: Color = .white,
        height: CGFloat = 160,
        width: CGFloat = 68
    ) {
        self._value = value
        self.accentColor = accentColor
        self.height = height
        self.width = width
    }
    
    public var body: some View {
        GeometryReader { _ in
            let normalized = max(0.0, min(1.0, value / 100.0))
            
            ZStack(alignment: .bottom) {
                // Background Track
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(Color.primary.opacity(0.12))
                
                // Active Fill
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(accentColor)
                    .frame(height: height * CGFloat(normalized))
                
                // Centered Icon & Status
                VStack {
                    if isDragging {
                        Text("\(Int(value))%")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(normalized > 0.6 ? .black : .primary)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(normalized > 0.25 ? (accentColor == .white ? .black : .white) : .secondary)
                        .padding(.bottom, 18)
                }
                .padding(.top, 14)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: width / 2))
            .overlay(
                RoundedRectangle(cornerRadius: width / 2)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: isDragging)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        if !isDragging {
                            isDragging = true
                            HapticFeedback.light()
                        }
                        let translationY = gesture.location.y
                        let progress = 1.0 - (translationY / height)
                        let clamped = max(0.0, min(1.0, Double(progress)))
                        let newValue = round(clamped * 100)
                        if abs(newValue - value) >= 5 {
                            HapticFeedback.selection()
                        }
                        value = newValue
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            isDragging = false
                        }
                    }
            )
        }
        .frame(width: width, height: height)
    }
    
    private var iconName: String {
        if value <= 0 {
            return "speaker.slash.fill"
        } else if value < 33 {
            return "speaker.wave.1.fill"
        } else if value < 66 {
            return "speaker.wave.2.fill"
        } else {
            return "speaker.wave.3.fill"
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VerticalCapsuleVolumeSlider(value: .constant(65))
    }
}
