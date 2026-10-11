import SwiftUI

/// An ultra-clean minimalist tab bar with an illuminated sliding indicator line and glowing neon blur.
public struct MorphingLineTabBar: View {
    public let items: [TabBarItem]
    @Binding public var selectedTabId: String
    public var accentColor: Color
    public var linePosition: LinePosition
    
    public enum LinePosition {
        case top
        case bottom
    }
    
    @Namespace private var lineNamespace
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        accentColor: Color = .cyan,
        linePosition: LinePosition = .top
    ) {
        self.items = items
        self._selectedTabId = selectedTabId
        self.accentColor = accentColor
        self.linePosition = linePosition
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                let isSelected = selectedTabId == item.id
                let tint = item.tintColor ?? accentColor
                
                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTabId = item.id
                    }
                } label: {
                    VStack(spacing: 5) {
                        // Top Line Indicator
                        if linePosition == .top {
                            indicatorLine(isSelected: isSelected, tint: tint)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                                .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? tint : .secondary)
                                .scaleEffect(isSelected ? 1.15 : 1.0)
                            
                            Text(item.title)
                                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? tint : .secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .padding(.vertical, 6)
                        
                        // Bottom Line Indicator
                        if linePosition == .bottom {
                            indicatorLine(isSelected: isSelected, tint: tint)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(Color.primary.opacity(0.06))
                        .frame(height: 1),
                    alignment: linePosition == .top ? .top : .bottom
                )
        )
    }
    
    @ViewBuilder
    private func indicatorLine(isSelected: Bool, tint: Color) -> some View {
        ZStack {
            if isSelected {
                // Glow blur layer
                Capsule()
                    .fill(tint)
                    .frame(width: 36, height: 3)
                    .blur(radius: 4)
                    .matchedGeometryEffect(id: "glowLine", in: lineNamespace)
                
                // Solid line layer
                Capsule()
                    .fill(tint)
                    .frame(width: 28, height: 3)
                    .matchedGeometryEffect(id: "solidLine", in: lineNamespace)
            } else {
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 28, height: 3)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            MorphingLineTabBar(
                items: [
                    TabBarItem(id: "dashboard", title: "Metrics", icon: "chart.bar", activeIcon: "chart.bar.fill"),
                    TabBarItem(id: "servers", title: "Nodes", icon: "server.rack"),
                    TabBarItem(id: "logs", title: "Terminal", icon: "terminal", activeIcon: "terminal.fill"),
                    TabBarItem(id: "settings", title: "Config", icon: "gearshape", activeIcon: "gearshape.fill")
                ],
                selectedTabId: .constant("dashboard"),
                accentColor: .cyan,
                linePosition: .top
            )
        }
    }
}
