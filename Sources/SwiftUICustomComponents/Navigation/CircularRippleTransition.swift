import SwiftUI

/// A custom circular clip shape centered at a specific focal point with an animated radius.
public struct CircularRevealShape: Shape {
    public var center: CGPoint
    public var radius: CGFloat
    
    public var animatableData: CGFloat {
        get { radius }
        set { radius = newValue }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: center,
            radius: max(radius, 0.001),
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        return path
    }
}

/// A container that reveals a destination view expanding radially outward from the tap location.
public struct CircularRippleTransitionView<Content: View, Destination: View>: View {
    @Binding public var isPresented: Bool
    public let content: Content
    public let destination: Destination
    
    @State private var tapOrigin: CGPoint = .zero
    @State private var rippleRadius: CGFloat = 0
    @State private var isDestinationVisible: Bool = false
    
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destination: () -> Destination
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.destination = destination()
    }
    
    public var body: some View {
        GeometryReader { geo in
            let maxRadius = sqrt(pow(geo.size.width, 2) + pow(geo.size.height, 2)) * 1.2
            
            ZStack {
                // Base Content
                content
                
                // Destination Revealed by Expanding Circle
                if isDestinationVisible {
                    destination
                        .clipShape(
                            CircularRevealShape(center: tapOrigin, radius: rippleRadius)
                        )
                        .ignoresSafeArea()
                }
            }
            .onChange(of: isPresented) { presented in
                if presented {
                    triggerReveal(maxRadius: maxRadius)
                } else {
                    triggerDismiss()
                }
            }
        }
    }
    
    public func triggerAt(origin: CGPoint) {
        self.tapOrigin = origin
        self.isPresented = true
    }
    
    private func triggerReveal(maxRadius: CGFloat) {
        isDestinationVisible = true
        HapticFeedback.medium()
        withAnimation(.easeOut(duration: 0.55)) {
            rippleRadius = maxRadius
        }
    }
    
    private func triggerDismiss() {
        HapticFeedback.light()
        withAnimation(.easeIn(duration: 0.45)) {
            rippleRadius = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.46) {
            isDestinationVisible = false
        }
    }
}

#Preview {
    CircularRippleTransitionView(
        isPresented: .constant(false),
        content: {
            VStack(spacing: 20) {
                Text("Tap button to trigger circular ripple")
            }
        },
        destination: {
            ZStack {
                Color.purple.ignoresSafeArea()
                Text("Destination Screen Revealed!")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    )
}
