import SwiftUI

/// Available detents for the interactive bottom sheet.
public enum SheetDetent: CGFloat, CaseIterable {
    case collapsed = 100
    case half = 380
    case full = 680
}

/// A custom bottom sheet with multi-detent snapping, velocity gesture tracking, and glassmorphic blur.
public struct CustomBottomSheet<Content: View>: View {
    @Binding public var currentDetent: SheetDetent
    public var isDismissable: Bool
    public let content: Content
    
    @State private var dragTranslation: CGFloat = 0
    
    public init(
        currentDetent: Binding<SheetDetent>,
        isDismissable: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._currentDetent = currentDetent
        self.isDismissable = isDismissable
        self.content = content()
    }
    
    private var currentHeight: CGFloat {
        max(currentDetent.rawValue - dragTranslation, 60)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 36, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 12)
            
            // Sheet Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: currentHeight)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 16, y: -5)
        .gesture(
            DragGesture()
                .onChanged { val in
                    dragTranslation = val.translation.height
                }
                .onEnded { val in
                    let velocity = val.velocity.height
                    let translation = val.translation.height
                    
                    HapticFeedback.light()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        if velocity < -400 || translation < -100 {
                            // Expand up
                            if currentDetent == .collapsed {
                                currentDetent = .half
                            } else {
                                currentDetent = .full
                            }
                        } else if velocity > 400 || translation > 100 {
                            // Collapse down
                            if currentDetent == .full {
                                currentDetent = .half
                            } else {
                                currentDetent = .collapsed
                            }
                        }
                        dragTranslation = 0
                    }
                }
        )
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Color.gray.opacity(0.2).ignoresSafeArea()
        CustomBottomSheet(currentDetent: .constant(.half)) {
            VStack(spacing: 12) {
                Text("Custom Bottom Sheet").font(.headline)
                Text("Drag up or down with velocity to snap between detents.")
                    .font(.caption).foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
    }
}
