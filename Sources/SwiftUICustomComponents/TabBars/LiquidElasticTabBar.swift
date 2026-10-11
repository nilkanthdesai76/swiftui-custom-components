import SwiftUI

/// A floating glassmorphic tab bar with an elastic liquid pill indicator that smoothly slides between tabs.
public struct LiquidElasticTabBar: View {
    public let items: [TabBarItem]
    @Binding public var selectedTabId: String
    public var accentColor: Color
    public var backgroundColor: Color
    
    @Namespace private var animationNamespace
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        accentColor: Color = .blue,
        backgroundColor: Color = Color.primary.opacity(0.06)
    ) {
        self.items = items
        self._selectedTabId = selectedTabId
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            ForEach(items) { item in
                let isSelected = selectedTabId == item.id
                let tint = item.tintColor ?? accentColor
                
                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.72)) {
                        selectedTabId = item.id
                    }
                } label: {
                    ZStack {
                        // Sliding Elastic Pill Background
                        if isSelected {
                            Capsule()
                                .fill(tint.opacity(0.18))
                                .overlay(
                                    Capsule()
                                        .stroke(tint.opacity(0.35), lineWidth: 1)
                                )
                                .matchedGeometryEffect(id: "liquidPill", in: animationNamespace)
                        }
                        
                        VStack(spacing: 3) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                                    .font(.system(size: 19, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? tint : .secondary)
                                    .scaleEffect(isSelected ? 1.15 : 1.0)
                                    .offset(y: isSelected ? -1 : 0)
                                
                                // Badge
                                if let count = item.badgeCount, count > 0 {
                                    Text(count > 99 ? "99+" : "\(count)")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(Capsule().fill(Color.red))
                                        .offset(x: 10, y: -6)
                                }
                            }
                            
                            Text(item.title)
                                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? tint : .secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 12, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()
        VStack {
            Spacer()
            LiquidElasticTabBar(
                items: [
                    TabBarItem(id: "home", title: "Home", icon: "house", activeIcon: "house.fill"),
                    TabBarItem(id: "search", title: "Explore", icon: "magnifyingglass"),
                    TabBarItem(id: "alerts", title: "Alerts", icon: "bell", activeIcon: "bell.fill", badgeCount: 3),
                    TabBarItem(id: "profile", title: "Profile", icon: "person", activeIcon: "person.fill")
                ],
                selectedTabId: .constant("home")
            )
            .padding(.bottom, 20)
        }
    }
}
