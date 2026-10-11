import SwiftUI

/// A modern tab bar where the selected tab expands horizontally to reveal its text label within a colored capsule.
public struct ExpandingLabelTabBar: View {
    public let items: [TabBarItem]
    @Binding public var selectedTabId: String
    public var accentColor: Color
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        accentColor: Color = .purple
    ) {
        self.items = items
        self._selectedTabId = selectedTabId
        self.accentColor = accentColor
    }
    
    public init(
        items: [TabBarItem],
        selectedId: Binding<String>,
        accentColor: Color = .purple
    ) {
        self.items = items
        self._selectedTabId = selectedId
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(items) { item in
                let isSelected = selectedTabId == item.id
                let tint = item.tintColor ?? accentColor
                
                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTabId = item.id
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                            .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? .white : .secondary)
                        
                        if isSelected {
                            Text(item.title)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .fixedSize()
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, isSelected ? 16 : 12)
                    .background(
                        Capsule()
                            .fill(isSelected ? tint : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.12).ignoresSafeArea()
        VStack {
            Spacer()
            ExpandingLabelTabBar(
                items: [
                    TabBarItem(id: "home", title: "Home", icon: "house", activeIcon: "house.fill"),
                    TabBarItem(id: "discover", title: "Discover", icon: "safari", activeIcon: "safari.fill"),
                    TabBarItem(id: "saved", title: "Bookmarks", icon: "bookmark", activeIcon: "bookmark.fill"),
                    TabBarItem(id: "profile", title: "Account", icon: "person", activeIcon: "person.fill")
                ],
                selectedTabId: .constant("discover"),
                accentColor: .purple
            )
            .padding(.bottom, 20)
        }
    }
}
