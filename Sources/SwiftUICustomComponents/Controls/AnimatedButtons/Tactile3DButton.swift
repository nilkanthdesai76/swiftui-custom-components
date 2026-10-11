import SwiftUI

/// A tactile 3D button that depresses physically into the surface on touch with spring rebound physics.
public struct Tactile3DButton: View {
    public let title: String
    public let icon: String?
    public var faceColor: Color
    public var depthColor: Color
    public var action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        faceColor: Color = Color(red: 0.20, green: 0.65, blue: 0.95),
        depthColor: Color = Color(red: 0.12, green: 0.45, blue: 0.75),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.faceColor = faceColor
        self.depthColor = depthColor
        self.action = action
    }
    
    public var body: some View {
        Button {
            HapticFeedback.medium()
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
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .buttonStyle(TactileDepthButtonStyle(faceColor: faceColor, depthColor: depthColor))
    }
}

private struct TactileDepthButtonStyle: ButtonStyle {
    let faceColor: Color
    let depthColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let depth: CGFloat = 5
        
        return ZStack {
            // Depth Base
            RoundedRectangle(cornerRadius: 16)
                .fill(depthColor)
                .offset(y: depth)
            
            // Top Face
            RoundedRectangle(cornerRadius: 16)
                .fill(faceColor)
                .offset(y: isPressed ? depth : 0)
            
            configuration.label
                .offset(y: isPressed ? depth : 0)
        }
        .frame(height: 52)
        .animation(.spring(response: 0.15, dampingFraction: 0.65), value: isPressed)
    }
}

#Preview {
    Tactile3DButton(title: "Press 3D Button", icon: "cube.fill") {}
        .padding()
}
