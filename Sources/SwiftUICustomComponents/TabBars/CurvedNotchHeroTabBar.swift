import SwiftUI

/// A custom curve shape that dips smoothly in the center to cradle a hero action button.
public struct CurvedNotchShape: Shape {
    public var notchRadius: CGFloat = 32
    public var curveDepth: CGFloat = 28
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: midX - notchRadius - 16, y: 0))
        
        // Left entry curve
        path.addCurve(
            to: CGPoint(x: midX - notchRadius + 4, y: curveDepth * 0.5),
            control1: CGPoint(x: midX - notchRadius - 4, y: 0),
            control2: CGPoint(x: midX - notchRadius, y: curveDepth * 0.3)
        )
        
        // Center valley
        path.addCurve(
            to: CGPoint(x: midX + notchRadius - 4, y: curveDepth * 0.5),
            control1: CGPoint(x: midX - notchRadius * 0.5, y: curveDepth),
            control2: CGPoint(x: midX + notchRadius * 0.5, y: curveDepth)
        )
        
        // Right exit curve
        path.addCurve(
            to: CGPoint(x: midX + notchRadius + 16, y: 0),
            control1: CGPoint(x: midX + notchRadius, y: curveDepth * 0.3),
            control2: CGPoint(x: midX + notchRadius + 4, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

/// An edge-to-edge curved bottom tab bar featuring a concave center notch with an elevated hero action button.
public struct CurvedNotchHeroTabBar: View {
    public let leftItems: [TabBarItem]
    public let rightItems: [TabBarItem]
    @Binding public var selectedTabId: String
    public var heroIcon: String
    public var heroColor: Color
    public var onHeroAction: () -> Void
    
    @State private var isHeroRotated: Bool = false
    
    public init(
        leftItems: [TabBarItem],
        rightItems: [TabBarItem],
        selectedTabId: Binding<String>,
        heroIcon: String = "plus",
        heroColor: Color = .blue,
        onHeroAction: @escaping () -> Void = {}
    ) {
        self.leftItems = leftItems
        self.rightItems = rightItems
        self._selectedTabId = selectedTabId
        self.heroIcon = heroIcon
        self.heroColor = heroColor
        self.onHeroAction = onHeroAction
    }
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        heroIcon: String = "plus",
        heroColor: Color = .blue,
        onHeroAction: @escaping () -> Void = {}
    ) {
        let mid = items.count / 2
        self.leftItems = Array(items.prefix(mid))
        self.rightItems = Array(items.suffix(items.count - mid))
        self._selectedTabId = selectedTabId
        self.heroIcon = heroIcon
        self.heroColor = heroColor
        self.onHeroAction = onHeroAction
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // Background Curved Dock
            CurvedNotchShape()
                .fill(.ultraThinMaterial)
                .overlay(
                    CurvedNotchShape()
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.07), radius: 10, y: -3)
                .frame(height: 72)
            
            // Tab Items Layout
            HStack(spacing: 0) {
                // Left Items
                HStack(spacing: 0) {
                    ForEach(leftItems) { item in
                        tabButton(item)
                    }
                }
                
                // Center Spacing for Hero Button
                Spacer()
                    .frame(width: 72)
                
                // Right Items
                HStack(spacing: 0) {
                    ForEach(rightItems) { item in
                        tabButton(item)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            // Elevated Hero Action Button
            Button {
                HapticFeedback.medium()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    isHeroRotated.toggle()
                }
                onHeroAction()
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [heroColor, heroColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: heroColor.opacity(0.4), radius: 8, y: 4)
                    
                    Image(systemName: heroIcon)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isHeroRotated ? 45 : 0))
                }
            }
            .offset(y: -18)
        }
    }
    
    private func tabButton(_ item: TabBarItem) -> some View {
        let isSelected = selectedTabId == item.id
        
        return Button {
            HapticFeedback.selection()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTabId = item.id
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                    .font(.system(size: 19, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? heroColor : .secondary)
                    .scaleEffect(isSelected ? 1.12 : 1.0)
                
                Text(item.title)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? heroColor : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()
        VStack {
            Spacer()
            CurvedNotchHeroTabBar(
                leftItems: [
                    TabBarItem(id: "home", title: "Feed", icon: "house", activeIcon: "house.fill"),
                    TabBarItem(id: "search", title: "Search", icon: "magnifyingglass")
                ],
                rightItems: [
                    TabBarItem(id: "activity", title: "Activity", icon: "bell", activeIcon: "bell.fill"),
                    TabBarItem(id: "profile", title: "Profile", icon: "person", activeIcon: "person.fill")
                ],
                selectedTabId: .constant("home"),
                onHeroAction: {}
            )
        }
    }
}
