import SwiftUI

/// Data model representing a color swatch token.
public struct ColorSwatchItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let color: Color
    public let hexCode: String
    
    public init(id: String, name: String, color: Color, hexCode: String) {
        self.id = id
        self.name = name
        self.color = color
        self.hexCode = hexCode
    }
}

/// An interactive color palette swatch picker with expanding circular rings, tactile spring checkmarks, and token readouts.
public struct ColorPaletteSwatchPicker: View {
    public let swatches: [ColorSwatchItem]
    @Binding public var selectedId: String
    
    public init(
        swatches: [ColorSwatchItem],
        selectedId: Binding<String>
    ) {
        self.swatches = swatches
        self._selectedId = selectedId
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            ForEach(swatches) { swatch in
                let isSelected = selectedId == swatch.id
                
                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                        selectedId = swatch.id
                    }
                } label: {
                    ZStack {
                        // Outer selection halo ring
                        if isSelected {
                            Circle()
                                .stroke(swatch.color, lineWidth: 2.5)
                                .frame(width: 44, height: 44)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Swatch circle
                        Circle()
                            .fill(swatch.color)
                            .frame(width: 34, height: 34)
                            .shadow(color: swatch.color.opacity(0.4), radius: 6, y: 3)
                        
                        // Inner checkmark icon
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .transition(.scale)
                        }
                    }
                    .frame(width: 46, height: 46)
                    .scaleEffect(isSelected ? 1.08 : 1.0)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ColorPaletteSwatchPicker(
        swatches: [
            ColorSwatchItem(id: "blue", name: "Electric Blue", color: .blue, hexCode: "#007AFF"),
            ColorSwatchItem(id: "purple", name: "Neon Violet", color: .purple, hexCode: "#AF52DE"),
            ColorSwatchItem(id: "pink", name: "Cyber Pink", color: .pink, hexCode: "#FF2D55"),
            ColorSwatchItem(id: "orange", name: "Sunset Orange", color: .orange, hexCode: "#FF9500"),
            ColorSwatchItem(id: "green", name: "Mint Emerald", color: Color(red: 16/255, green: 185/255, blue: 129/255), hexCode: "#10B981")
        ],
        selectedId: .constant("blue")
    )
}
