import SwiftUI

/// Data container representing a hero card item in the collection.
public struct HeroCardItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let category: String
    public let imageName: String
    public let gradientColors: [Color]
    public let detailedDescription: String
    
    public init(
        id: String,
        title: String,
        subtitle: String,
        category: String,
        imageName: String = "sparkles",
        gradientColors: [Color] = [.purple, .blue],
        detailedDescription: String = "Detailed view with seamless matched geometry and physics-based gesture dismissal."
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.imageName = imageName
        self.gradientColors = gradientColors
        self.detailedDescription = detailedDescription
    }
}

/// A container that coordinates App Store Today-style card expansions into fullscreen detail views with drag-to-dismiss physics.
public struct HeroCardContainerView: View {
    public let cards: [HeroCardItem]
    @Binding public var selectedCard: HeroCardItem?
    
    @Namespace private var heroNamespace
    @State private var dragOffset: CGSize = .zero
    
    public init(cards: [HeroCardItem], selectedCard: Binding<HeroCardItem?>) {
        self.cards = cards
        self._selectedCard = selectedCard
    }
    
    public var body: some View {
        ZStack {
            // Scrollable List of Hero Cards
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(cards) { card in
                        if selectedCard?.id != card.id {
                            heroCardRow(card)
                        } else {
                            // Invisible placeholder holding layout position
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.clear)
                                .frame(height: 280)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .opacity(selectedCard == nil ? 1 : 0.4)
            
            // Fullscreen Expanded Detail View
            if let card = selectedCard {
                expandedDetailView(card)
                    .zIndex(10)
            }
        }
    }
    
    // MARK: - Collapsed Card Row
    private func heroCardRow(_ card: HeroCardItem) -> some View {
        Button {
            HapticFeedback.light()
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                selectedCard = card
            }
        } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: card.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .matchedGeometryEffect(id: "bg-\(card.id)", in: heroNamespace)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(card.category.uppercased())
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                        .matchedGeometryEffect(id: "category-\(card.id)", in: heroNamespace)
                    
                    Text(card.title)
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .matchedGeometryEffect(id: "title-\(card.id)", in: heroNamespace)
                    
                    Text(card.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "subtitle-\(card.id)", in: heroNamespace)
                }
                .padding(20)
            }
            .frame(height: 280)
            .shadow(color: card.gradientColors.first?.opacity(0.35) ?? Color.black.opacity(0.2), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Fullscreen Detail View
    private func expandedDetailView(_ card: HeroCardItem) -> some View {
        let dragProgress = min(max(dragOffset.height / 300, 0), 1)
        let scale = 1.0 - (dragProgress * 0.15)
        let cornerRadius: CGFloat = 22 * dragProgress
        
        return ZStack(alignment: .topTrailing) {
            Color.black.opacity(1.0 - Double(dragProgress) * 0.8)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Banner
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: card.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .matchedGeometryEffect(id: "bg-\(card.id)", in: heroNamespace)
                            .frame(height: 380)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(card.category.uppercased())
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.8))
                                .matchedGeometryEffect(id: "category-\(card.id)", in: heroNamespace)
                            
                            Text(card.title)
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(.white)
                                .matchedGeometryEffect(id: "title-\(card.id)", in: heroNamespace)
                            
                            Text(card.subtitle)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .matchedGeometryEffect(id: "subtitle-\(card.id)", in: heroNamespace)
                        }
                        .padding(24)
                    }
                    
                    // Detailed Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Interactive Experience")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(card.detailedDescription)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                        
                        Text("Swipe down anywhere on this screen to fluidly shrink and dismiss back into the catalog.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                            .padding()
                            .adaptiveBackground()
                    }
                    .padding(24)
                }
            }
            .scaleEffect(scale)
            .offset(y: max(dragOffset.height, 0))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 120 || value.velocity.height > 800 {
                            HapticFeedback.light()
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                selectedCard = nil
                                dragOffset = .zero
                            }
                        } else {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            
            // Close Button
            Button {
                HapticFeedback.light()
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    selectedCard = nil
                    dragOffset = .zero
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.black.opacity(0.5)))
            }
            .padding(.top, 50)
            .padding(.trailing, 20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HeroCardContainerView(
        cards: [
            HeroCardItem(id: "1", title: "Liquid Design Principles", subtitle: "Fluid interfaces and spatial physics", category: "Featured Story", gradientColors: [.purple, .indigo]),
            HeroCardItem(id: "2", title: "Haptic Micro-Interactions", subtitle: "Tactile sensation in modern iOS apps", category: "Deep Dive", gradientColors: [.orange, .pink])
        ],
        selectedCard: .constant(nil)
    )
}
