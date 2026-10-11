import SwiftUI

/// Performs a 3D spatial cube turnover transition between two views.
public struct Spatial3DCubeTransitionView<ViewA: View, ViewB: View>: View {
    @Binding public var isRotatedToB: Bool
    public let viewA: ViewA
    public let viewB: ViewB
    
    public init(
        isRotatedToB: Binding<Bool>,
        @ViewBuilder viewA: () -> ViewA,
        @ViewBuilder viewB: () -> ViewB
    ) {
        self._isRotatedToB = isRotatedToB
        self.viewA = viewA()
        self.viewB = viewB()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Front Face (View A)
                viewA
                    .rotation3DEffect(
                        .degrees(isRotatedToB ? -90 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: .trailing,
                        perspective: 0.7
                    )
                    .opacity(isRotatedToB ? 0 : 1)
                
                // Side Face (View B)
                viewB
                    .rotation3DEffect(
                        .degrees(isRotatedToB ? 0 : 90),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: .leading,
                        perspective: 0.7
                    )
                    .opacity(isRotatedToB ? 1 : 0)
            }
        }
    }
}

#Preview {
    Spatial3DCubeTransitionView(
        isRotatedToB: .constant(false),
        viewA: {
            ZStack {
                Color.blue.ignoresSafeArea()
                Text("Front Cube Face (Screen A)").foregroundColor(.white).font(.headline)
            }
        },
        viewB: {
            ZStack {
                Color.pink.ignoresSafeArea()
                Text("Side Cube Face (Screen B)").foregroundColor(.white).font(.headline)
            }
        }
    )
}
