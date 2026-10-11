import SwiftUI
import Combine

public struct SegmentItem: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    
    public init(id: String, title: String, icon: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

public struct LiquidSegmentedPicker: View {
    @Binding public var selectedId: String
    public var items: [SegmentItem]
    public var accentColor: Color
    
    @Namespace private var animationNamespace
    
    public init(
        selectedId: Binding<String>,
        items: [SegmentItem],
        accentColor: Color = .blue
    ) {
        self._selectedId = selectedId
        self.items = items
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
                let isSelected = selectedId == item.id
                
                Button {
                    guard selectedId != item.id else { return }
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                        selectedId = item.id
                    }
                } label: {
                    HStack(spacing: 6) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .font(.system(size: 13, weight: .bold))
                        }
                        Text(item.title)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(isSelected ? .white : .secondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .background {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(accentColor)
                                .matchedGeometryEffect(id: "SEGMENT_PILL", in: animationNamespace)
                                .shadow(color: accentColor.opacity(0.35), radius: 6, y: 2)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.primary.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}
