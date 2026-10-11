import SwiftUI
import Combine

public enum ButtonActionState: Equatable {
    case idle
    case loading
    case success
    case error
}

public struct MorphingStateButton: View {
    @Binding public var state: ButtonActionState
    public var title: String
    public var icon: String
    public var accentColor: Color
    public var action: () -> Void
    
    @State private var rotation: Double = 0
    @State private var errorOffset: CGFloat = 0
    
    public init(
        state: Binding<ButtonActionState>,
        title: String = "Process Payment",
        icon: String = "arrow.up.circle.fill",
        accentColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self._state = state
        self.title = title
        self.icon = icon
        self.accentColor = accentColor
        self.action = action
    }
    
    public var body: some View {
        Button {
            guard state == .idle else { return }
            HapticFeedback.medium()
            action()
        } label: {
            ZStack {
                // Background Capsule / Circle
                Capsule()
                    .fill(backgroundFill)
                    .frame(
                        width: state == .idle ? nil : 54,
                        height: 52
                    )
                    .overlay(
                        Capsule()
                            .stroke(borderColor, lineWidth: 1.5)
                    )
                    .shadow(color: shadowColor, radius: 10, y: 4)
                
                // Content inside button
                Group {
                    switch state {
                    case .idle:
                        HStack(spacing: 8) {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .bold))
                            Text(title)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                        
                    case .loading:
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(width: 24, height: 24)
                            .rotationEffect(.degrees(rotation))
                            .onAppear {
                                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                                    rotation = 360
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                        
                    case .success:
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                        
                    case .error:
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .offset(x: errorOffset)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
        }
        .buttonStyle(.plain)
        .disabled(state != .idle)
        .onChange(of: state) { newState in
            if newState == .error {
                withAnimation(.default.repeatCount(4, autoreverses: true).speed(4)) {
                    errorOffset = 8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    errorOffset = 0
                }
            }
        }
    }
    
    private var backgroundFill: Color {
        switch state {
        case .idle:
            return accentColor
        case .loading:
            return accentColor.opacity(0.8)
        case .success:
            return .green
        case .error:
            return .red
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .idle:
            return accentColor.opacity(0.6)
        case .loading:
            return Color.white.opacity(0.3)
        case .success:
            return Color.green.opacity(0.8)
        case .error:
            return Color.red.opacity(0.8)
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .idle:
            return accentColor.opacity(0.35)
        case .loading:
            return accentColor.opacity(0.2)
        case .success:
            return Color.green.opacity(0.4)
        case .error:
            return Color.red.opacity(0.4)
        }
    }
}
