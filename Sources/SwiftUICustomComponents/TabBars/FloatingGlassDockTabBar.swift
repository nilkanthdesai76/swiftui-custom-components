import SwiftUI

/// A macOS/iPadOS dock-inspired floating glass tab bar with spring hover/scale physics and active glowing dot indicators.
public struct FloatingGlassDockTabBar: View {
    public let items: [TabBarItem]
    @Binding public var selectedTabId: String
    public var accentColor: Color
    
    @Namespace private var dockNamespace
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        accentColor: Color = .blue
    ) {
        self.items = items
        self._selectedTabId = selectedTabId
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            ForEach(items) { item in
                let isSelected = selectedTabId == item.id
                let tint = item.tintColor ?? accentColor
                
                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.68)) {
                        selectedTabId = item.id
                    }
                } label: {
                    VStack(spacing: 5) {
                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(tint.opacity(0.2))
                                        .matchedGeometryEffect(id: "dockActiveBg", in: dockNamespace)
                                }
                                
                                Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                                    .font(.system(size: 21, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? tint : .secondary)
                                    .frame(width: 44, height: 44)
                            }
                            
                            if let count = item.badgeCount, count > 0 {
                                Text("\(count)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(Capsule().fill(Color.red))
                                    .offset(x: 4, y: -2)
                            }
                        }
                        
                        // Active Glowing Indicator Dot
                        Circle()
                            .fill(isSelected ? tint : Color.clear)
                            .frame(width: 4, height: 4)
                            .shadow(color: isSelected ? tint : .clear, radius: 3)
                    }
                    .scaleEffect(isSelected ? 1.14 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 14, y: 6)
        )
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()
        FloatingGlassDockTabBar(
            items: [
                TabBarItem(id: "home", title: "Feed", icon: "house"),
                TabBarItem(id: "search", title: "Search", icon: "magnifyingglass"),
                TabBarItem(id: "chat", title: "Messages", icon: "bubble.left.and.bubble.right", badgeCount: 3),
                TabBarItem(id: "settings", title: "Config", icon: "gearshape")
            ],
            selectedTabId: .constant("home")
        )
    }
}
