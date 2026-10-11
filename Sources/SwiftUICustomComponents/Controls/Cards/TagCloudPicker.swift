import SwiftUI
import Combine

public struct TagItem: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let icon: String?
    
    public init(id: String, name: String, icon: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

public struct TagCloudPicker: View {
    public var tags: [TagItem]
    @Binding public var selectedTags: Set<String>
    public var accentColor: Color
    
    public init(
        tags: [TagItem],
        selectedTags: Binding<Set<String>>,
        accentColor: Color = .purple
    ) {
        self.tags = tags
        self._selectedTags = selectedTags
        self.accentColor = accentColor
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags) { tag in
                    let isSelected = selectedTags.contains(tag.id)
                    
                    Button {
                        HapticFeedback.selection()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.68)) {
                            if isSelected {
                                selectedTags.remove(tag.id)
                            } else {
                                selectedTags.insert(tag.id)
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            if let icon = tag.icon {
                                Image(systemName: icon)
                                    .font(.system(size: 12, weight: .bold))
                            }
                            Text(tag.name)
                                .font(.system(size: 13, weight: .semibold))
                            
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .foregroundColor(isSelected ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? accentColor : Color.primary.opacity(0.06))
                        )
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? accentColor : Color.primary.opacity(0.12), lineWidth: 1)
                        )
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 4)
        }
    }
}
