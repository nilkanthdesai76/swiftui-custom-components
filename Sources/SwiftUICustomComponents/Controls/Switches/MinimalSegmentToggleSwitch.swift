import SwiftUI

/// A clean minimalist segment switch featuring dual SF Symbol icons and a smooth sliding thumb pill with tactile magnetic snap.
public struct MinimalSegmentToggleSwitch: View {
    @Binding public var isOn: Bool
    public var onIcon: String
    public var offIcon: String
    public var onColor: Color
    public var offColor: Color
    
    @Namespace private var toggleNamespace
    
    public init(
        isOn: Binding<Bool>,
        onIcon: String = "bell.fill",
        offIcon: String = "bell.slash.fill",
        onColor: Color = .blue,
        offColor: Color = .gray
    ) {
        self._isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.onColor = onColor
        self.offColor = offColor
    }
    
    public var body: some View {
        Button {
            HapticFeedback.selection()
            withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                // OFF State Side
                ZStack {
                    if !isOn {
                        Capsule()
                            .fill(Color.appSystemBackground)
                            .shadow(color: Color.black.opacity(0.12), radius: 4, y: 1)
                            .matchedGeometryEffect(id: "thumbPill", in: toggleNamespace)
                    }
                    
                    Image(systemName: offIcon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(!isOn ? offColor : .secondary.opacity(0.6))
                        .frame(width: 38, height: 32)
                }
                
                // ON State Side
                ZStack {
                    if isOn {
                        Capsule()
                            .fill(Color.appSystemBackground)
                            .shadow(color: Color.black.opacity(0.12), radius: 4, y: 1)
                            .matchedGeometryEffect(id: "thumbPill", in: toggleNamespace)
                    }
                    
                    Image(systemName: onIcon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isOn ? onColor : .secondary.opacity(0.6))
                        .frame(width: 38, height: 32)
                }
            }
            .padding(3)
            .background(
                Capsule()
                    .fill(isOn ? onColor.opacity(0.2) : Color.primary.opacity(0.08))
            )
            .overlay(
                Capsule()
                    .stroke(isOn ? onColor.opacity(0.4) : Color.primary.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MinimalSegmentToggleSwitch(isOn: .constant(true))
}
