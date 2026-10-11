import SwiftUI

/// A navigation container that presents child views as progressive layered card sheets with background depth scaling.
public struct SheetStackContainerView<BackgroundContent: View, SheetContent: View>: View {
    @Binding public var isSheetPresented: Bool
    public let backgroundContent: BackgroundContent
    public let sheetContent: SheetContent
    
    @State private var dragOffset: CGFloat = 0
    
    public init(
        isSheetPresented: Binding<Bool>,
        @ViewBuilder backgroundContent: () -> BackgroundContent,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self._isSheetPresented = isSheetPresented
        self.backgroundContent = backgroundContent()
        self.sheetContent = sheetContent()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Screen
                backgroundContent
                    .scaleEffect(isSheetPresented ? 0.92 : 1.0)
                    .clipShape(RoundedRectangle(cornerRadius: isSheetPresented ? 24 : 0))
                    .overlay(
                        Color.black
                            .opacity(isSheetPresented ? 0.35 : 0)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if isSheetPresented {
                                    dismissSheet()
                                }
                            }
                    )
                    .animation(.spring(response: 0.38, dampingFraction: 0.8), value: isSheetPresented)
                
                // Stacked Card Sheet
                if isSheetPresented {
                    sheetContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.appSystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: Color.black.opacity(0.15), radius: 20, y: -5)
                        .offset(y: max(dragOffset, 0))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .gesture(
                            DragGesture()
                                .onChanged { val in
                                    if val.translation.height > 0 {
                                        dragOffset = val.translation.height
                                    }
                                }
                                .onEnded { val in
                                    if val.translation.height > 150 || val.velocity.height > 900 {
                                        dismissSheet()
                                    } else {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .padding(.top, 44)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
    
    private func dismissSheet() {
        HapticFeedback.light()
        withAnimation(.spring(response: 0.38, dampingFraction: 0.8)) {
            isSheetPresented = false
            dragOffset = 0
        }
    }
}

#Preview {
    SheetStackContainerView(
        isSheetPresented: .constant(true),
        backgroundContent: {
            ZStack {
                Color.blue.ignoresSafeArea()
                Text("Main Background Content").foregroundColor(.white)
            }
        },
        sheetContent: {
            VStack(spacing: 20) {
                Capsule().fill(Color.gray.opacity(0.4)).frame(width: 40, height: 5).padding(.top, 12)
                Text("Stacked Depth Card Sheet").font(.headline)
                Spacer()
            }
        }
    )
}
