import SwiftUI
import Combine
import SwiftUICustomComponents

public enum ComponentCategory: String, CaseIterable, Identifiable {
    case tabBars = "Tab Bars (6)"
    case transitions = "Transitions (4)"
    case controls = "Controls (24)"
    case backgrounds = "Backgrounds (4)"
    
    public var id: String { rawValue }
}

public enum ControlsSubCategory: String, CaseIterable, Identifiable {
    case buttons = "Buttons (9)"
    case sliders = "Sliders (5)"
    case switches = "Switches (5)"
    case pickers = "Pickers & 3D (5)"
    
    public var id: String { rawValue }
}

public struct ShowcaseGalleryView: View {
    @State private var selectedCategory: ComponentCategory = .tabBars
    
    // Tab Bar State
    @State private var activeTabId: String = "home"
    @State private var selectedTabAccentColor: Color = .blue
    @State private var morphingLinePosition: MorphingLineTabBar.LinePosition = .top
    @State private var heroButtonAngle: Double = 0
    @State private var heroActionMessage: String = "Tap hero (+) to trigger action"
    @State private var sampleBadgeCount: Int = 4
    
    // Navigation Transitions State
    @State private var selectedHeroCard: HeroCardItem? = nil
    @State private var isRipplePresented: Bool = false
    @State private var rippleColorIndex: Int = 0
    @State private var isCubeFlipped: Bool = false
    @State private var isSheetStackPresented: Bool = false
    
    // Controls State
    @State private var selectedControlsSubCategory: ControlsSubCategory = .buttons
    
    // Buttons State
    @State private var isSlideConfirmed: Bool = false
    @State private var morphingButtonState: ButtonActionState = .idle
    @State private var burstCount: Int = 0
    @State private var neonTapCount: Int = 0
    @State private var magneticPressCount: Int = 0
    @State private var glowTapCount: Int = 0
    
    // Sliders & Dials State
    @State private var dialValue: Double = 72
    @State private var waveformProgress: Double = 0.42
    @State private var sliderValue: Double = 65
    @State private var steppedSliderValue: Int = 2
    @State private var verticalVolumeValue: Double = 68
    
    // Switches State
    @State private var isNightTheme: Bool = false
    @State private var isAppLocked: Bool = true
    @State private var isGlowSwitchOn: Bool = true
    @State private var isLiquidSwitchOn: Bool = true
    @State private var isMuteSwitchOn: Bool = false
    
    // Pickers & Cards State
    @State private var selectedSegment: String = "weekly"
    @State private var stepperValue: Int = 3
    @State private var selectedTags: Set<String> = ["swiftui", "design"]
    @State private var selectedColorSwatchId: String = "blue"
    
    // Background State
    @State private var selectedBackground: Int = 0
    @State private var backgroundAnimationSpeed: Double = 1.0
    
    var sampleTabs: [TabBarItem] {
        [
            TabBarItem(id: "home", title: "Feed", icon: "house", activeIcon: "house.fill"),
            TabBarItem(id: "search", title: "Explore", icon: "magnifyingglass"),
            TabBarItem(id: "alerts", title: "Alerts", icon: "bell", activeIcon: "bell.fill", badgeCount: sampleBadgeCount),
            TabBarItem(id: "profile", title: "Account", icon: "person", activeIcon: "person.fill")
        ]
    }
    
    let sampleHeroCards = [
        HeroCardItem(
            id: "card-1",
            title: "Spatial Fluid Interfaces",
            subtitle: "Physics, spring tension, and gesture tracking",
            category: "Design Architecture",
            imageName: "sparkles",
            gradientColors: [Color.purple, Color.indigo],
            detailedDescription: "Learn how modern iOS applications leverage matchedGeometryEffect and velocity tracking to make navigation feel like interacting with physical materials."
        ),
        HeroCardItem(
            id: "card-2",
            title: "Haptic Micro-Interactions",
            subtitle: "Tactile sensations that elevate user delight",
            category: "Engineering Craft",
            imageName: "hand.tap.fill",
            gradientColors: [Color.orange, Color.pink],
            detailedDescription: "Subtle tactile clicks and pops reinforce state transitions, giving users immediate confidence when completing critical workflows."
        )
    ]
    
    let sampleSegments = [
        SegmentItem(id: "daily", title: "Daily", icon: "calendar"),
        SegmentItem(id: "weekly", title: "Weekly", icon: "flame.fill"),
        SegmentItem(id: "monthly", title: "Monthly", icon: "chart.bar.fill")
    ]
    
    let sampleTags = [
        TagItem(id: "swiftui", name: "SwiftUI", icon: "swift"),
        TagItem(id: "design", name: "iOS Design", icon: "paintbrush.fill"),
        TagItem(id: "haptics", name: "Haptics", icon: "hand.tap.fill"),
        TagItem(id: "physics", name: "Spring Physics", icon: "waveform"),
        TagItem(id: "shaders", name: "Metal Shaders", icon: "sparkles")
    ]
    
    let sampleColorSwatches = [
        ColorSwatchItem(id: "blue", name: "Electric Blue", color: .blue, hexCode: "#007AFF"),
        ColorSwatchItem(id: "purple", name: "Neon Violet", color: .purple, hexCode: "#AF52DE"),
        ColorSwatchItem(id: "pink", name: "Cyber Pink", color: .pink, hexCode: "#FF2D55"),
        ColorSwatchItem(id: "orange", name: "Sunset Orange", color: .orange, hexCode: "#FF9500"),
        ColorSwatchItem(id: "green", name: "Mint Emerald", color: Color(red: 16/255, green: 185/255, blue: 129/255), hexCode: "#10B981")
    ]
    
    let rippleGradients: [[Color]] = [
        [Color.purple, Color.indigo, Color.black],
        [Color.cyan, Color.blue, Color.black],
        [Color(red: 16/255, green: 185/255, blue: 129/255), Color.teal, Color.black]
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Background Layer (When viewing Backgrounds tab)
                if selectedCategory == .backgrounds {
                    activeBackgroundView
                } else {
                    Color.appSystemBackground.ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    // Header Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ComponentCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    
                    // Main Content Canvas
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            switch selectedCategory {
                            case .tabBars:
                                tabBarsSection
                            case .transitions:
                                transitionsSection
                            case .controls:
                                controlsSection
                            case .backgrounds:
                                backgroundsSection
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 60)
                    }
                }
            }
            .navigationTitle("Component Kit")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
    
    // MARK: - 1. Tab Bars Showcase (6 Dedicated Cards)
    
    private var tabBarsSection: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "6 Animated Navigation Tab Bars",
                desc: "Fluid bottom navigation docks with elastic springs, concave hero curves, illuminated laser lines, dynamic expanding capsules, water bubbles, and magnifying glass docks."
            )
            
            // Interactive Tab State Inspector Stage
            showcaseCard(
                title: "Live Active Tab Inspector",
                badge: "INTERACTIVE STAGE",
                desc: "Tap any tab on any bar below to observe synchronous state updates, tactile haptics, and spring kinematics.",
                badgeColor: selectedTabAccentColor
            ) {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(selectedTabAccentColor.opacity(0.18))
                                .frame(width: 58, height: 58)
                            
                            Image(systemName: sampleTabs.first(where: { $0.id == activeTabId })?.activeIcon ?? "house.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(selectedTabAccentColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Tab: \(sampleTabs.first(where: { $0.id == activeTabId })?.title ?? "")")
                                .font(.headline.bold())
                            
                            Text("Identifier: \"\(activeTabId)\" • Unread: \(sampleBadgeCount)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                sampleBadgeCount = (sampleBadgeCount + 1) % 10
                            }
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "bell.badge.fill")
                                    .font(.caption)
                                Text("+1 Badge")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .foregroundColor(selectedTabAccentColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(selectedTabAccentColor.opacity(0.12)))
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Accent Color Switcher
                    HStack(spacing: 10) {
                        Text("Dock Accent:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        ForEach([Color.blue, Color.purple, Color.cyan, Color.orange, Color.emeraldColor], id: \.description) { col in
                            Circle()
                                .fill(col)
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedTabAccentColor == col ? 2 : 0)
                                )
                                .scaleEffect(selectedTabAccentColor == col ? 1.2 : 1.0)
                                .onTapGesture {
                                    HapticFeedback.selection()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTabAccentColor = col
                                    }
                                }
                        }
                        Spacer()
                    }
                }
            }
            
            // 1. Liquid Elastic Tab Bar
            showcaseCard(
                title: "1. Liquid Elastic Capsule Tab Bar",
                badge: "LIQUID SPRING",
                desc: "Floating glass capsule with an elastic matchedGeometry pill that stretches and slides across items with spring momentum.",
                badgeColor: .blue
            ) {
                VStack(spacing: 12) {
                    LiquidElasticTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        accentColor: selectedTabAccentColor
                    )
                }
            }
            
            // 2. Curved Notch Hero Tab Bar
            showcaseCard(
                title: "2. Curved Notch Center Hero Tab Bar",
                badge: "CONCAVE NOTCH",
                desc: "Edge-to-edge curved bottom bar with a central concave valley cradling an elevated hero action button with rotation physics.",
                badgeColor: .purple
            ) {
                VStack(spacing: 14) {
                    CurvedNotchHeroTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        heroColor: selectedTabAccentColor
                    ) {
                        HapticFeedback.medium()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                            heroButtonAngle += 45
                            heroActionMessage = "Hero Action Executed! (\(Int(heroButtonAngle))°)"
                        }
                    }
                    
                    Text(heroActionMessage)
                        .font(.caption.bold())
                        .foregroundColor(selectedTabAccentColor)
                }
            }
            
            // 3. Morphing Glow Line Tab Bar
            showcaseCard(
                title: "3. Morphing Illuminated Line Tab Bar",
                badge: "LASER LINE",
                desc: "Minimalist navigation featuring a laser-thin sliding neon line indicator with 8pt glow bloom and selectable dock alignment.",
                badgeColor: .cyan
            ) {
                VStack(spacing: 14) {
                    HStack {
                        Text("Indicator Position:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Spacer()
                        Picker("Line Position", selection: $morphingLinePosition) {
                            Text("Top Line").tag(MorphingLineTabBar.LinePosition.top)
                            Text("Bottom Line").tag(MorphingLineTabBar.LinePosition.bottom)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 190)
                    }
                    
                    MorphingLineTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        accentColor: selectedTabAccentColor,
                        linePosition: morphingLinePosition
                    )
                }
            }
            
            // 4. Expanding Label Capsule Tab Bar
            showcaseCard(
                title: "4. Expanding Label Dynamic Pill Tab Bar",
                badge: "DYNAMIC PILL",
                desc: "Inactive items remain compact icon-only badges. The selected tab smoothly expands horizontally with spring physics to reveal its title.",
                badgeColor: .orange
            ) {
                VStack(spacing: 12) {
                    ExpandingLabelTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        accentColor: selectedTabAccentColor
                    )
                }
            }
            
            // 5. Floating Bubble Water Ripple Tab Bar
            showcaseCard(
                title: "5. Floating Bubble Water Ripple Tab Bar",
                badge: "INDEPENDENT BUBBLES",
                desc: "Separated spherical glass orbs with radial ambient halos and light spring compression on tap.",
                badgeColor: .emeraldColor
            ) {
                VStack(spacing: 12) {
                    FloatingBubbleTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        accentColor: selectedTabAccentColor
                    )
                }
            }
            
            // 6. Floating Glass Dock Tab Bar
            showcaseCard(
                title: "6. Floating Glass Dock Tab Bar",
                badge: "MAGNIFYING DOCK",
                desc: "macOS/iPadOS dock-inspired floating glass bar with magnifying scale physics on selection and active glowing indicator dots.",
                badgeColor: .indigo
            ) {
                VStack(spacing: 12) {
                    FloatingGlassDockTabBar(
                        items: sampleTabs,
                        selectedTabId: $activeTabId,
                        accentColor: selectedTabAccentColor
                    )
                }
            }
        }
    }
    
    // MARK: - 2. Transitions Showcase (4 Dedicated Elevated Cards)
    
    private var transitionsSection: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "4 Fluid Navigation Transitions",
                desc: "Spatial navigation paradigms: App Store-style hero expansions, touch-coordinate radial ripple reveals, 3D perspective cube turnovers, and layered receding depth sheets."
            )
            
            // 1. Hero Card Zoom
            showcaseCard(
                title: "1. Hero Card Zoom (App Store Style)",
                badge: "MATCHED GEOMETRY",
                desc: "Tap any card below to watch it expand smoothly into an immersive detail view with matched geometry, spring curve, and interactive drag-down dismissal.",
                badgeColor: .purple
            ) {
                VStack(spacing: 12) {
                    ForEach(sampleHeroCards) { card in
                        Button {
                            withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                                selectedHeroCard = card
                            }
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(
                                            LinearGradient(
                                                colors: card.gradientColors,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 52, height: 52)
                                    Image(systemName: card.imageName)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(card.category.uppercased())
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.purple)
                                    Text(card.title)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.primary)
                                    Text(card.subtitle)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.purple)
                            }
                            .padding(12)
                            .background(Color.primary.opacity(0.04))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // 2. Circular Ripple Reveal
            showcaseCard(
                title: "2. Circular Ripple Radial Mask Reveal",
                badge: "TOUCH VECTOR MASK",
                desc: "Destination view blossoms radially outward from the exact coordinate of the user's touch vector, calculated using geometric Pythagorean hypotenuse bounds.",
                badgeColor: .cyan
            ) {
                VStack(spacing: 14) {
                    HStack {
                        Text("Ripple Palette:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        Picker("Palette", selection: $rippleColorIndex) {
                            Text("Violet Midnight").tag(0)
                            Text("Cyber Blue").tag(1)
                            Text("Mint Emerald").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Button {
                        isRipplePresented = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "circle.circle.fill")
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Trigger Circular Ripple Reveal")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Tap anywhere on this button to set origin")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: rippleGradients[rippleColorIndex].prefix(2).map { $0 },
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color.purple.opacity(0.3), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .circularRipple(isPresented: $isRipplePresented) {
                ZStack {
                    LinearGradient(
                        colors: rippleGradients[rippleColorIndex],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 18) {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.system(size: 56))
                            .foregroundColor(.white)
                        
                        Text("Circular Ripple Radial Reveal")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Clip mask calculated dynamically from your touch vector coordinates.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Button {
                            isRipplePresented = false
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle.fill")
                                Text("Dismiss Transition")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.white))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 16)
                    }
                    .padding()
                }
            }
            
            // 3. Spatial 3D Cube Turnover
            showcaseCard(
                title: "3. Spatial 3D Cube Turnover",
                badge: "3D PERSPECTIVE",
                desc: "Flips views around a 3D Y-axis anchor point with 0.7 perspective depth factor, simulating a rotating solid cube interface.",
                badgeColor: .orange
            ) {
                VStack(spacing: 14) {
                    Spatial3DCubeTransitionView(
                        isRotatedToB: $isCubeFlipped,
                        viewA: {
                            cubeFace(title: "Front View: Operational Dashboard", color: .blue, icon: "chart.line.uptrend.xyaxis")
                        },
                        viewB: {
                            cubeFace(title: "Reverse View: System Telemetry", color: .orange, icon: "cpu.fill")
                        }
                    )
                    .frame(height: 150)
                    
                    HStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                                isCubeFlipped.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text(isCubeFlipped ? "Flip Back to Front Face" : "Rotate 3D Cube Perspective")
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 12).fill(isCubeFlipped ? Color.orange : Color.blue))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // 4. Stacked Depth Sheet Presentation
            showcaseCard(
                title: "4. Stacked Depth Sheet Presentation",
                badge: "LAYERED RECEDING",
                desc: "Presenting view recedes into the background to 0.92x scale with 24pt corner radius morph and 35% ambient dimming while child sheet slides upward with interactive drag dismissal.",
                badgeColor: .emeraldColor
            ) {
                VStack(spacing: 14) {
                    Button {
                        isSheetStackPresented = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Present Stacked Depth Sheet")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Inspect background recessing & gesture physics")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.emeraldColor)
                        )
                        .shadow(color: Color.emeraldColor.opacity(0.3), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .fullScreenCover(isPresented: $isSheetStackPresented) {
            SheetStackContainerView(
                isSheetPresented: $isSheetStackPresented,
                backgroundContent: {
                    ZStack {
                        LinearGradient(
                            colors: [Color.indigo, Color.purple, Color.black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        VStack(spacing: 14) {
                            Image(systemName: "rectangle.stack.badge.person.crop")
                                .font(.system(size: 52))
                                .foregroundColor(.white)
                            Text("Parent Background View")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text("Recedes to 0.92x scale with 24pt corner radius and 35% dimming layer.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    }
                },
                sheetContent: {
                    VStack(spacing: 20) {
                        Capsule()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 44, height: 5)
                            .padding(.top, 14)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Progressive Depth Sheet")
                                    .font(.title3.bold())
                                Text("Interactive downward drag with spring snapping")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                isSheetStackPresented = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "hand.draw.fill")
                                    .foregroundColor(.blue)
                                Text("Swipe down from anywhere on the card to dismiss.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
            )
        }
    }
    
    private func cubeFace(title: String, color: Color, icon: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                Text(title)
                    .font(.headline.bold())
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
    
    // MARK: - 3. Controls Showcase (24 Controls, Sheet removed)
    
    private var controlsSection: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "24 Custom UI Controls & Micro-Interactions",
                desc: "Tactile haptic feedback, physical spring resistance, continuous light sweeps, magnetic touch tracking, and gyroscopic 3D cards."
            )
            
            // Sub-category Navigation
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(ControlsSubCategory.allCases) { sub in
                        let isSelected = selectedControlsSubCategory == sub
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.72)) {
                                selectedControlsSubCategory = sub
                            }
                        } label: {
                            Text(sub.rawValue)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(isSelected ? .white : .primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color.blue : Color.primary.opacity(0.06))
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(isSelected ? Color.blue : Color.primary.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
            
            // Active Sub-category Controls
            VStack(spacing: 18) {
                switch selectedControlsSubCategory {
                case .buttons:
                    buttonsGroup
                case .sliders:
                    slidersGroup
                case .switches:
                    switchesGroup
                case .pickers:
                    pickersGroup
                }
            }
        }
    }
    
    // MARK: - Buttons Subgroup (9 Components)
    
    private var buttonsGroup: some View {
        VStack(spacing: 16) {
            // 1. Slide To Confirm
            showcaseCard(
                title: "1. Slide to Confirm / Unlock",
                badge: "GESTURE ACTION",
                desc: "Swipe the circular thumb across the track. Springs back if cancelled, locks with haptics when reaching 85%+ threshold.",
                badgeColor: .blue
            ) {
                VStack(spacing: 12) {
                    SlideToConfirmControl(
                        isConfirmed: $isSlideConfirmed,
                        title: "Slide to Deploy Order",
                        confirmedTitle: "Order Confirmed!",
                        thumbColor: .blue
                    )
                    
                    if isSlideConfirmed {
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                isSlideConfirmed = false
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset Slide Handle")
                            }
                            .font(.caption.bold())
                            .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // 2. Morphing State Button
            showcaseCard(
                title: "2. Morphing State Button",
                badge: "STATE MACHINE",
                desc: "Smoothly transitions between Idle, Loading spinner, Success checkmark bounce, and Error shake states.",
                badgeColor: .purple
            ) {
                VStack(spacing: 14) {
                    MorphingStateButton(
                        state: $morphingButtonState,
                        title: "Deploy Contract",
                        icon: "arrow.up.circle.fill",
                        accentColor: .purple
                    ) {
                        morphingButtonState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            morphingButtonState = .success
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                morphingButtonState = .idle
                            }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Button("Trigger Success") {
                            morphingButtonState = .loading
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                morphingButtonState = .success
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.primary.opacity(0.08)))
                        
                        Button("Trigger Error") {
                            morphingButtonState = .loading
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                morphingButtonState = .error
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    morphingButtonState = .idle
                                }
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.primary.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // 3. Neon Orbiting Border Button
            showcaseCard(
                title: "3. Neon Orbiting Border Button",
                badge: "CYBERPUNK",
                desc: "Traveling angular LED perimeter light trail with dark frosted glass core and neon glow blur.",
                badgeColor: .cyan
            ) {
                NeonBorderPulseButton(
                    title: "Initialize Matrix Protocol (\(neonTapCount))",
                    icon: "bolt.fill",
                    neonColor: .cyan
                ) {
                    neonTapCount += 1
                }
            }
            
            // 4. Magnetic Spring Press (NEW)
            showcaseCard(
                title: "4. Magnetic Spring Press Button",
                badge: "MAGNETIC DRAG",
                desc: "Magnetically attracts and follows finger drag displacement with spring resistance, snapping back with tactile click upon release.",
                badgeColor: .indigo
            ) {
                VStack(spacing: 10) {
                    MagneticSpringButton(
                        title: "Magnetic Fluid Press (\(magneticPressCount))",
                        icon: "cursorarrow.rays",
                        accentColor: .indigo
                    ) {
                        magneticPressCount += 1
                    }
                    
                    Text("Drag in any direction to feel physical spring tension")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // 5. Glassmorphic Glow Button (NEW)
            showcaseCard(
                title: "5. Glassmorphic Glow Button",
                badge: "NEON REFRACTION",
                desc: "Frosted glass pill button with dual continuous neon gradient borders, glowing specular highlights, and spring press depression.",
                badgeColor: .pink
            ) {
                VStack(spacing: 10) {
                    GlassmorphicGlowButton(
                        title: "Launch Hyperdrive (\(glowTapCount))",
                        icon: "paperplane.fill",
                        glowColors: [Color.purple, Color.cyan]
                    ) {
                        glowTapCount += 1
                    }
                }
            }
            
            // 6. Liquid Hold to Confirm
            showcaseCard(
                title: "6. Hold 1.2s Liquid Fill Button",
                badge: "PRESSURE HOLD",
                desc: "Requires continuous finger pressure. Liquid wave rises upward with haptic burst upon 100% completion.",
                badgeColor: .green
            ) {
                LiquidFillProgressButton(
                    title: "Hold 1.2s to Transfer Funds",
                    completedTitle: "Transfer Completed!",
                    fillColor: .green
                ) {}
            }
            
            // 7. Particle Confetti Burst
            showcaseCard(
                title: "7. Confetti Particle Burst Button",
                badge: "CELEBRATION",
                desc: "Fires 8 radial confetti physics particles exploding outward with random velocities and spring fade.",
                badgeColor: .pink
            ) {
                ParticleBurstButton(
                    title: "Celebrate Milestone (\(burstCount))",
                    icon: "sparkles",
                    tintColor: .pink
                ) {
                    burstCount += 1
                }
            }
            
            // 8. Continuous Shimmer Pulse
            showcaseCard(
                title: "8. Continuous Shimmer Pulse Button",
                badge: "LIGHT SWEEP",
                desc: "Diagonal 45° light ray passing across button face with tactile compression on tap.",
                badgeColor: .indigo
            ) {
                ShimmerPulseButton(title: "Explore Premium Features", icon: "crown.fill") {}
            }
            
            // 9. Tactile 3D Physical Push
            showcaseCard(
                title: "9. Tactile 3D Physical Push Button",
                badge: "PHYSICS BEVEL",
                desc: "Simulates an authentic mechanical keyboard keycap with 6pt bottom bevel depth and shadow depression.",
                badgeColor: .orange
            ) {
                Tactile3DButton(title: "Tactile Mechanical Press", icon: "cube.fill") {}
            }
        }
    }
    
    // MARK: - Sliders Subgroup (5 Components)
    
    private var slidersGroup: some View {
        VStack(spacing: 16) {
            // 1. Circular Dial Slider
            showcaseCard(
                title: "1. Circular Rotary Dial Slider",
                badge: "ROTARY KNOB",
                desc: "260° circular progress arc with touch vector angle calculation, haptic clicks, and central readout.",
                badgeColor: .orange
            ) {
                CircularDialSlider(
                    value: $dialValue,
                    range: 0...100,
                    title: "OUTPUT POWER",
                    unit: "%",
                    tintColor: .orange
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            }
            
            // 2. Vertical Capsule Volume Slider (NEW)
            showcaseCard(
                title: "2. Vertical Capsule Volume Slider",
                badge: "CONTROL CENTER",
                desc: "iOS Control Center-style vertical capsule slider with tactile vertical drag physics, morphing audio symbols, and percentage readout.",
                badgeColor: .blue
            ) {
                VStack(spacing: 12) {
                    HStack(spacing: 30) {
                        VerticalCapsuleVolumeSlider(
                            value: $verticalVolumeValue,
                            accentColor: .blue,
                            height: 150,
                            width: 64
                        )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Volume Output")
                                .font(.headline.bold())
                            Text("\(Int(verticalVolumeValue))% Active Level")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            Text("Drag vertically inside capsule to test smooth audio symbol morphing.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            // 3. Waveform Audio Scrubber
            showcaseCard(
                title: "3. Interactive Waveform Audio Scrubber",
                badge: "AUDIO TIMELINE",
                desc: "24 dynamic amplitude bars with drag scrubber head, played progress highlight, and timestamp readout.",
                badgeColor: .purple
            ) {
                WaveformAudioScrubber(
                    progress: $waveformProgress,
                    duration: 215,
                    playedColor: .purple
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            
            // 4. Elastic Bubble Tooltip Slider
            showcaseCard(
                title: "4. Elastic Bubble Tooltip Slider",
                badge: "SPRING STRETCH",
                desc: "Speech bubble tooltip wobbles and stretches dynamically based on user drag speed.",
                badgeColor: .blue
            ) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Current Intensity")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(sliderValue))%")
                            .font(.caption.bold())
                            .foregroundColor(.blue)
                    }
                    ElasticBubbleSlider(value: $sliderValue)
                }
                .padding(.horizontal, 6)
            }
            
            // 5. Stepped Haptic Tick Slider
            showcaseCard(
                title: "5. Stepped Haptic Tick Slider",
                badge: "MAGNETIC NOTCHES",
                desc: "Discrete notched step positions with tactile magnetic snapping on each division.",
                badgeColor: .teal
            ) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Selected Setting")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Stage \(steppedSliderValue + 1) of 5")
                            .font(.caption.bold())
                            .foregroundColor(.teal)
                    }
                    SteppedHapticTickSlider(currentStep: $steppedSliderValue, totalSteps: 5)
                }
                .padding(.horizontal, 6)
            }
        }
    }
    
    // MARK: - Switches Subgroup (5 Components)
    
    private var switchesGroup: some View {
        VStack(spacing: 16) {
            // 1. Day / Night Celestial
            showcaseCard(
                title: "1. Celestial Day & Night Switch",
                badge: "PHOTOREALISTIC",
                desc: "Rotating Sun with radiating solar beams morphs into a cratered Moon across a starry midnight sky.",
                badgeColor: .indigo
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isNightTheme ? "Midnight Realm" : "Daylight Solar")
                            .font(.subheadline.bold())
                        Text(isNightTheme ? "Moon and starfield active" : "Sun rays and clear sky")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    DayNightThemeSwitch(isNight: $isNightTheme)
                }
            }
            
            // 2. Minimal Segment Toggle Switch (NEW)
            showcaseCard(
                title: "2. Minimal Segment Toggle Switch",
                badge: "MAGNETIC DUAL-ICON",
                desc: "Clean minimalist capsule switch with dual SF Symbol icons and a smooth sliding thumb pill with tactile magnetic snap.",
                badgeColor: .blue
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isMuteSwitchOn ? "Alerts Silenced" : "Alerts Active")
                            .font(.subheadline.bold())
                        Text(isMuteSwitchOn ? "Do not disturb enabled" : "Ring on incoming messages")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    MinimalSegmentToggleSwitch(
                        isOn: $isMuteSwitchOn,
                        onIcon: "bell.fill",
                        offIcon: "bell.slash.fill",
                        onColor: .blue
                    )
                }
            }
            
            // 3. Padlock Security Switch
            showcaseCard(
                title: "3. Security Padlock Switch",
                badge: "BIOMETRIC LOCK",
                desc: "Physical shackle springs upward to unlock with status label and encrypted tactile sensation.",
                badgeColor: .emeraldColor
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isAppLocked ? "Encrypted & Secured" : "Biometrics Verified")
                            .font(.subheadline.bold())
                        Text(isAppLocked ? "Requires passcode" : "Access granted")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    LockUnlockSwitch(isLocked: $isAppLocked)
                }
            }
            
            // 4. Glow Toggle Tube Switch
            showcaseCard(
                title: "4. Neon Glow Tube Toggle",
                badge: "ILLUMINATED",
                desc: "Floating neon power thumb gliding over a frosted glass illuminated track.",
                badgeColor: .green
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isGlowSwitchOn ? "Core Powered ON" : "Standby Mode")
                            .font(.subheadline.bold())
                        Text(isGlowSwitchOn ? "Neon tube emitting light" : "Low energy draw")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    GlowToggleSwitch(isOn: $isGlowSwitchOn, glowColor: .green)
                }
            }
            
            // 5. Liquid Stretch Switch
            showcaseCard(
                title: "5. Viscous Liquid Stretch Switch",
                badge: "FLUID ELASTIC",
                desc: "Thumb physically elongates and stretches along the drag direction before snapping into position.",
                badgeColor: .purple
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isLiquidSwitchOn ? "Viscous Surface Active" : "Liquid Inert")
                            .font(.subheadline.bold())
                        Text("Elongates during drag transition")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    LiquidStretchSwitch(isOn: $isLiquidSwitchOn, onColor: .purple)
                }
            }
        }
    }
    
    // MARK: - Pickers Subgroup (5 Components)
    
    private var pickersGroup: some View {
        VStack(spacing: 16) {
            // 1. Color Palette Swatch Token Picker (NEW)
            showcaseCard(
                title: "1. Color Palette Swatch Token Picker",
                badge: "HALO EXPAND",
                desc: "Design token color picker with expanding circular halo rings, tactile spring checkmarks, and hex code readouts.",
                badgeColor: .purple
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    ColorPaletteSwatchPicker(
                        swatches: sampleColorSwatches,
                        selectedId: $selectedColorSwatchId
                    )
                    
                    if let activeSwatch = sampleColorSwatches.first(where: { $0.id == selectedColorSwatchId }) {
                        HStack {
                            Text("Token: \(activeSwatch.name)")
                                .font(.caption.bold())
                            Spacer()
                            Text(activeSwatch.hexCode)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // 2. Interactive 3D Tilt Card
            showcaseCard(
                title: "2. 3D Perspective Interactive Tilt Card",
                badge: "GYROSCOPIC TOUCH",
                desc: "Drag your finger over the card. Rotates in true 3D space with specular glare light reflection matching your touch vector.",
                badgeColor: .indigo
            ) {
                InteractiveTiltCard(maxAngle: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                LinearGradient(
                                    colors: [Color.indigo, Color.purple, Color.black],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("DRAG ME")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.white.opacity(0.2)))
                            }
                            
                            Spacer()
                            
                            Text("Spatial Perspective")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            Text("Touch and drag across the surface to tilt with real-time specular lighting glare.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(20)
                    }
                }
                .frame(height: 170)
            }
            
            // 3. Liquid Segmented Picker
            showcaseCard(
                title: "3. Liquid Glass Segmented Picker",
                badge: "MATCHED GEOMETRY",
                desc: "Sliding matchedGeometryEffect capsule dock with spring bounce and active glow shadow.",
                badgeColor: .blue
            ) {
                VStack(spacing: 10) {
                    LiquidSegmentedPicker(
                        selectedId: $selectedSegment,
                        items: sampleSegments,
                        accentColor: .blue
                    )
                    
                    Text("Selected Interval: \(selectedSegment.capitalized)")
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                }
            }
            
            // 4. Haptic Elastic Stepper
            showcaseCard(
                title: "4. Haptic Elastic Number Stepper",
                badge: "SPRING BOUNCE",
                desc: "Animated numeric counter whose badge bounces and scales with tactile clicks on tap.",
                badgeColor: .orange
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Participant Quantity")
                            .font(.subheadline.bold())
                        Text("Range: 1 to 20 seats")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    HapticElasticStepper(
                        value: $stepperValue,
                        range: 1...20,
                        tintColor: .orange
                    )
                }
            }
            
            // 5. Tag Cloud Chip Filter
            showcaseCard(
                title: "5. Multi-Select Tag Cloud Filter",
                badge: "CHIP SELECTOR",
                desc: "Interactive filter tags with selection checkmarks, spring scale, and multi-selection state.",
                badgeColor: .pink
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    TagCloudPicker(
                        tags: sampleTags,
                        selectedTags: $selectedTags,
                        accentColor: .pink
                    )
                    
                    Text("\(selectedTags.count) Tags Selected")
                        .font(.caption.bold())
                        .foregroundColor(.pink)
                }
            }
        }
    }
    
    // MARK: - 4. Backgrounds Showcase (Studio & 4 Shaders)
    
    private var backgroundsSection: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "4 Live Procedural Backgrounds",
                desc: "High-performance GPU-accelerated backgrounds: chromatic fluid aurora, drifting soft bokeh orbs, 60fps canvas starfield, and perspective synthwave cyber grid."
            )
            
            // Background Studio Controller Card
            showcaseCard(
                title: "Background Studio & Shader Controller",
                badge: "GPU CANVAS",
                desc: "Switch between procedural shaders and adjust animation speed parameters live.",
                badgeColor: .purple
            ) {
                VStack(spacing: 16) {
                    Picker("Background", selection: $selectedBackground) {
                        Text("Aurora").tag(0)
                        Text("Bokeh").tag(1)
                        Text("Starfield").tag(2)
                        Text("Cyber Grid").tag(3)
                    }
                    .pickerStyle(.segmented)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Motion Velocity Speed")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.1fx Speed", backgroundAnimationSpeed))
                                .font(.caption.bold())
                                .foregroundColor(.purple)
                        }
                        
                        Slider(value: $backgroundAnimationSpeed, in: 0.5...2.5, step: 0.1)
                            .tint(.purple)
                    }
                }
            }
            
            // Live Frosted Glass Preview Card (Demonstrates real UI layered over procedural background)
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Layered Glass Contrast Test")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Text("Frosted ultra-thin material resting over live shaders")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Button("Action Button") {}
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.purple))
                    
                    Text("60 FPS Smooth")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.white.opacity(0.2)))
                    
                    Spacer()
                }
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
            
            // 4 Algorithm Information Cards
            showcaseCard(
                title: "1. Multilayer Harmonic Aurora Mesh",
                badge: "RADIAL GRADIENTS",
                desc: "Three harmonic circular color centers pulsating along dynamic trigonometric orbits with 50pt Gaussian blur.",
                badgeColor: .purple
            ) {
                HStack {
                    Text("Orbits: 3 Sine/Cosine Centers • Blur: 50pt • Blend: Screen")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            showcaseCard(
                title: "2. Physics-Based Drifting Bokeh Orbs",
                badge: "FLOATING PARTICLES",
                desc: "Serene multi-radius chromatic orbs gently floating across screen bounds with soft blur diffusion.",
                badgeColor: .blue
            ) {
                HStack {
                    Text("Orbs: 4 Primary Nodes • Radius: 130-180pt • Drift: 30pt amplitude")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            showcaseCard(
                title: "3. 60 FPS Canvas Starfield Particles",
                badge: "GPU CANVAS",
                desc: "High-density particle dust system rendered on a hardware-accelerated Canvas with sinusoidal twinkling brightness.",
                badgeColor: .cyan
            ) {
                HStack {
                    Text("Stars: 50 Nodes • Twinkle: 2.0 rad/s • Render: SwiftUI Canvas")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            showcaseCard(
                title: "4. Perspective Synthwave Cyber Grid",
                badge: "RETRO PERSPECTIVE",
                desc: "Vanishing point raycasting with horizontal logarithmic scanning lines and horizon bloom glow.",
                badgeColor: .pink
            ) {
                HStack {
                    Text("Horizon: 45% screen • Rays: 14 lines • Step Factor: 1.35x exponential")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var activeBackgroundView: some View {
        switch selectedBackground {
        case 0:
            AuroraMeshGradientView()
        case 1:
            FloatingBokehOrbsView()
        case 2:
            StarfieldParticlesView()
        case 3:
            CyberGridMatrixView(speed: backgroundAnimationSpeed)
        default:
            EmptyView()
        }
    }
    
    // MARK: - Helper UI
    
    private func headerCard(title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline.bold())
                .foregroundColor(.primary)
            Text(desc)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.appSecondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func showcaseCard<Content: View>(
        title: String,
        badge: String,
        desc: String,
        badgeColor: Color = .blue,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row with Title & Badge
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Text(badge)
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(badgeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(badgeColor.opacity(0.12))
                    )
            }
            
            Text(desc)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Interactive Element Area
            VStack {
                content()
            }
            .padding(.vertical, 4)
        }
        .padding(16)
        .background(Color.appSecondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

extension Color {
    static var emeraldColor: Color {
        Color(red: 16/255, green: 185/255, blue: 129/255)
    }
}
