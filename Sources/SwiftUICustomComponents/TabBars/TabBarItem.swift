import SwiftUI

/// Represents an item displayed in any of the custom tab bars.
public struct TabBarItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let activeIcon: String?
    public let badgeCount: Int?
    public let tintColor: Color?
    
    public init(
        id: String,
        title: String,
        icon: String,
        activeIcon: String? = nil,
        badgeCount: Int? = nil,
        tintColor: Color? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.activeIcon = activeIcon
        self.badgeCount = badgeCount
        self.tintColor = tintColor
    }
}
