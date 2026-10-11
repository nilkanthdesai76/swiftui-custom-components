import SwiftUI

/// A playful floating tab bar made of independent glass bubbles that pulse with water-ripple physics.
public struct FloatingBubbleTabBar: View {
    public let items: [TabBarItem]
    @Binding public var selectedTabId: String
    public var accentColor: Color
    
    public init(
        items: [TabBarItem],
        selectedTabId: Binding<String>,
        accentColor: Color = Color(red: 0.15, green: 0.75, blue: 0.95)
    ) {
        self.items = items
        self._selectedTabId = selectedTabId
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            ForEach(items) { item in
                let isSelected = selectedTabId == item.id
                let tint = item.tintColor ?? accentColor
                
                Button {
                    HapticFeedback.light()
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.65)) {
                        selectedTabId = item.id
                    }
                } label: {
                    ZStack {
                        // Ambient halo
                        if isSelected {
                            Circle()
                                .fill(tint.opacity(0.3))
                                .frame(width: 48, height: 48)
                                .blur(radius: 6)
                        }
                        
                        Circle()
                            .fill(isSelected ? tint : Color.primary.opacity(0.06))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? Color.white.opacity(0.4) : Color.primary.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: isSelected ? tint.opacity(0.4) : Color.black.opacity(0.06), radius: 8, y: 3)
                        
                        Image(systemName: isSelected ? (item.activeIcon ?? item.icon) : item.icon)
                            .font(.system(size: 19, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? .white : .secondary)
                            .scaleEffect(isSelected ? 1.15 : 1.0)
                    }
                    .scaleEffect(isSelected ? 1.08 : 1.0)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            FloatingBubbleTabBar(
                items: [
                    TabBarItem(id: "home", title: "Home", icon: "sparkles"),
                    TabBarItem(id: "music", title: "Music", icon: "waveform"),
                    TabBarItem(id: "heart", title: "Likes", icon: "heart.fill", tintColor: .pink),
                    TabBarItem(id: "user", title: "Profile", icon: "person.crop.circle")
                ],
                selectedTabId: .constant("music")
            )
            .padding(.bottom, 20)
        }
    }
}
