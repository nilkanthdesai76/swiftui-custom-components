import SwiftUI
import Combine
import SwiftUICustomComponents

public enum ComponentCategory: String, CaseIterable, Identifiable {
    case tabBars = "Tab Bars (5)"
    case transitions = "Transitions (4)"
    case controls = "Controls (20)"
    case backgrounds = "Backgrounds (3)"
    
    public var id: String { rawValue }
}

public enum ControlsSubCategory: String, CaseIterable, Identifiable {
    case buttons = "Buttons (7)"
    case sliders = "Sliders (4)"
    case switches = "Switches (4)"
    case pickers = "Pickers & 3D (4)"
    case drawer = "Sheet (1)"
    
    public var id: String { rawValue }
}

public struct ShowcaseGalleryView: View {
    @State private var selectedCategory: ComponentCategory = .controls
    
    // Tab Bar State
    @State private var selectedTabBarStyle: Int = 0
    @State private var activeTabId: String = "home"
    
    // Navigation State
    @State private var selectedHeroCard: HeroCardItem? = nil
    @State private var isRipplePresented: Bool = false
    @State private var isCubeFlipped: Bool = false
    @State private var isSheetStackPresented: Bool = false
    
    // Controls State
    @State private var selectedControlsSubCategory: ControlsSubCategory = .buttons
    
    // Buttons State
    @State private var isSlideConfirmed: Bool = false
    @State private var morphingButtonState: ButtonActionState = .idle
    @State private var burstCount: Int = 0
    @State private var neonTapCount: Int = 0
    
    // Sliders & Dials State
    @State private var dialValue: Double = 72
    @State private var waveformProgress: Double = 0.42
    @State private var sliderValue: Double = 65
    @State private var steppedSliderValue: Int = 2
    
    // Switches State
    @State private var isNightTheme: Bool = false
    @State private var isAppLocked: Bool = true
    @State private var isGlowSwitchOn: Bool = true
    @State private var isLiquidSwitchOn: Bool = true
    
    // Pickers & Cards State
    @State private var selectedSegment: String = "weekly"
    @State private var stepperValue: Int = 3
    @State private var selectedTags: Set<String> = ["swiftui", "design"]
    
    // Drawer State
    @State private var isCustomSheetOpen: Bool = false
    @State private var sheetDetent: SheetDetent = .half
    
    // Background State
    @State private var selectedBackground: Int = 0
    
    let sampleTabs = [
        TabBarItem(id: "home", title: "Feed", icon: "house", activeIcon: "house.fill"),
        TabBarItem(id: "search", title: "Explore", icon: "magnifyingglass"),
        TabBarItem(id: "alerts", title: "Alerts", icon: "bell", activeIcon: "bell.fill", badgeCount: 4),
        TabBarItem(id: "profile", title: "Account", icon: "person", activeIcon: "person.fill")
    ]
    
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
                                tabBarsShowcase
                            case .transitions:
                                transitionsShowcase
                            case .controls:
                                controlsShowcase
                            case .backgrounds:
                                backgroundsShowcase
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
    
    // MARK: - 1. Tab Bars Showcase
    
    private var tabBarsShowcase: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "5 Unique Animated Tab Bars",
                desc: "Switch between custom bottom navigation bars with elastic springs, curved hero buttons, and glowing trackers."
            )
            
            Picker("Tab Bar Style", selection: $selectedTabBarStyle) {
                Text("Liquid Elastic").tag(0)
                Text("Curved Notch").tag(1)
                Text("Glow Line").tag(2)
                Text("Expanding").tag(3)
                Text("Floating").tag(4)
            }
            .pickerStyle(.segmented)
            
            // Active Tab Preview Content Card
            VStack(spacing: 16) {
                Image(systemName: sampleTabs.first(where: { $0.id == activeTabId })?.activeIcon ?? "house.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)
                    .padding(.top, 24)
                
                Text("Active Tab: \(sampleTabs.first(where: { $0.id == activeTabId })?.title ?? "")")
                    .font(.title3.bold())
                
                Text("Tap the tab items below to observe liquid morphing, haptic bursts, and spring physics.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Color.appSecondarySystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Live Tab Bar Rendering
            VStack(spacing: 8) {
                Text("LIVE INTERACTIVE TAB BAR")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                switch selectedTabBarStyle {
                case 0:
                    LiquidElasticTabBar(items: sampleTabs, selectedTabId: $activeTabId)
                case 1:
                    CurvedNotchHeroTabBar(items: sampleTabs, selectedTabId: $activeTabId) {}
                case 2:
                    MorphingLineTabBar(items: sampleTabs, selectedTabId: $activeTabId)
                case 3:
                    ExpandingLabelTabBar(items: sampleTabs, selectedTabId: $activeTabId)
                case 4:
                    FloatingBubbleTabBar(items: sampleTabs, selectedTabId: $activeTabId)
                default:
                    EmptyView()
                }
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - 2. Transitions Showcase
    
    private var transitionsShowcase: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "4 Fluid Navigation Transitions",
                desc: "Hero cards zoom seamlessly into detail sheets, circular ripple coordinates reveal content, and 3D space rotates."
            )
            
            // Hero Card Transition Section
            VStack(alignment: .leading, spacing: 12) {
                Text("1. HERO CARD ZOOM (APP STORE STYLE)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                ForEach(sampleHeroCards) { card in
                    Button {
                        selectedHeroCard = card
                    } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: card.gradientColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 54, height: 54)
                                Image(systemName: card.imageName)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.category.uppercased())
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.blue)
                                Text(card.title)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.primary)
                                Text(card.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }
                        .padding(14)
                        .background(Color.appSecondarySystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider()
            
            // Circular Ripple Reveal
            VStack(alignment: .leading, spacing: 12) {
                Text("2. CIRCULAR RIPPLE MASK TRANSITION")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Button {
                    isRipplePresented = true
                } label: {
                    HStack {
                        Image(systemName: "circle.circle.fill")
                        Text("Trigger Circular Ripple Reveal")
                        Spacer()
                        Image(systemName: "sparkles")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.purple))
                }
                .buttonStyle(.plain)
            }
            .circularRipple(isPresented: $isRipplePresented) {
                ZStack {
                    LinearGradient(
                        colors: [Color.purple, Color.indigo, Color.black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.system(size: 54))
                            .foregroundColor(.white)
                        Text("Circular Ripple Detail")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Text("Mask expanded from exact tap coordinate.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button("Dismiss Transition") {
                            isRipplePresented = false
                        }
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.white))
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            
            Divider()
            
            // Spatial 3D Cube Turnover
            VStack(alignment: .leading, spacing: 12) {
                Text("3. SPATIAL 3D CUBE TURNOVER")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Spatial3DCubeTransitionView(
                    isRotatedToB: $isCubeFlipped,
                    viewA: {
                        cubeFace(title: "Front View Interface", color: .blue, icon: "1.circle.fill")
                    },
                    viewB: {
                        cubeFace(title: "Reverse View Interface", color: .orange, icon: "2.circle.fill")
                    }
                )
                .frame(height: 140)
                
                Button {
                    isCubeFlipped.toggle()
                } label: {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text(isCubeFlipped ? "Flip Back to Front Face" : "Rotate 3D Cube Perspective")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary.opacity(0.06)))
                }
                .buttonStyle(.plain)
            }
            
            Divider()
            
            // Sheet Stack Presentation
            VStack(alignment: .leading, spacing: 12) {
                Text("4. STACKED DEPTH SHEET PRESENTATION")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Button {
                    isSheetStackPresented = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Present Depth Sheet Stack")
                        Spacer()
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.15)))
                }
                .buttonStyle(.plain)
            }
        }
        .fullScreenCover(isPresented: $isSheetStackPresented) {
            SheetStackContainerView(
                isSheetPresented: $isSheetStackPresented,
                backgroundContent: {
                    ZStack {
                        Color.indigo.ignoresSafeArea()
                        VStack(spacing: 12) {
                            Text("Parent Background View")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text("Scales back to 0.92x with rounded corners when sheet opens.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                },
                sheetContent: {
                    VStack(spacing: 20) {
                        Capsule().fill(Color.gray.opacity(0.4)).frame(width: 40, height: 5).padding(.top, 12)
                        Text("Progressive Depth Sheet").font(.headline)
                        Text("Drag down or tap background to dismiss.")
                            .font(.caption).foregroundColor(.secondary)
                        Spacer()
                        Button("Dismiss Sheet") {
                            isSheetStackPresented = false
                        }
                        .padding()
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
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.white)
        }
    }
    
    // MARK: - 3. Controls Showcase (20 Components)
    
    private var controlsShowcase: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "20 Custom UI Controls & Micro-Interactions",
                desc: "Tactile feedback, physical spring resistance, continuous light sweeps, and gyroscopic 3D cards."
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
                case .drawer:
                    drawerGroup
                }
            }
        }
    }
    
    // MARK: Sub-Groups
    
    private var buttonsGroup: some View {
        VStack(spacing: 16) {
            // 1. Slide To Confirm
            controlCard(
                title: "Slide to Confirm / Unlock",
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
            controlCard(
                title: "Morphing State Button",
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
            controlCard(
                title: "Neon Orbiting Border Button",
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
            
            // 4. Liquid Hold to Confirm
            controlCard(
                title: "Hold 1.2s Liquid Fill Button",
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
            
            // 5. Particle Confetti Burst
            controlCard(
                title: "Confetti Particle Burst",
                badge: "CELEBRATION",
                desc: "Fires 8 radial confetti physics particles exploding outward with random velocities and spring fade.",
                badgeColor: .pink
            ) {
                VStack(spacing: 8) {
                    ParticleBurstButton(
                        title: "Celebrate Milestone (\(burstCount))",
                        icon: "sparkles",
                        tintColor: .pink
                    ) {
                        burstCount += 1
                    }
                }
            }
            
            // 6. Shimmer Sweep
            controlCard(
                title: "Continuous Shimmer Pulse",
                badge: "LIGHT SWEEP",
                desc: "Diagonal 45° light ray passing across button face with tactile compression on tap.",
                badgeColor: .indigo
            ) {
                ShimmerPulseButton(title: "Explore Premium Features", icon: "crown.fill") {}
            }
            
            // 7. Tactile 3D Physical Push
            controlCard(
                title: "Tactile 3D Physical Push",
                badge: "PHYSICS BEVEL",
                desc: "Simulates an authentic mechanical keyboard keycap with 6pt bottom bevel depth and shadow depression.",
                badgeColor: .orange
            ) {
                Tactile3DButton(title: "Tactile Mechanical Press", icon: "cube.fill") {}
            }
        }
    }
    
    private var slidersGroup: some View {
        VStack(spacing: 16) {
            // 1. Circular Dial Slider
            controlCard(
                title: "Circular Rotary Dial Slider",
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
            
            // 2. Waveform Audio Scrubber
            controlCard(
                title: "Interactive Waveform Scrubber",
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
            
            // 3. Elastic Bubble Slider
            controlCard(
                title: "Elastic Bubble Tooltip Slider",
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
            
            // 4. Stepped Haptic Tick Slider
            controlCard(
                title: "Stepped Haptic Tick Slider",
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
    
    private var switchesGroup: some View {
        VStack(spacing: 16) {
            // 1. Day / Night Celestial
            controlCard(
                title: "Celestial Day & Night Switch",
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
            
            // 2. Padlock Security Switch
            controlCard(
                title: "Security Padlock Switch",
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
            
            // 3. Glow Toggle Tube Switch
            controlCard(
                title: "Neon Glow Tube Toggle",
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
            
            // 4. Liquid Stretch Switch
            controlCard(
                title: "Viscous Liquid Stretch Switch",
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
    
    private var pickersGroup: some View {
        VStack(spacing: 16) {
            // 1. Interactive 3D Tilt Card
            controlCard(
                title: "3D Perspective Interactive Tilt Card",
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
            
            // 2. Liquid Segmented Picker
            controlCard(
                title: "Liquid Glass Segmented Picker",
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
            
            // 3. Haptic Elastic Stepper
            controlCard(
                title: "Haptic Elastic Number Stepper",
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
            
            // 4. Tag Cloud Chip Filter
            controlCard(
                title: "Multi-Select Tag Cloud Filter",
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
    
    private var drawerGroup: some View {
        VStack(spacing: 16) {
            controlCard(
                title: "Multi-Detent Custom Bottom Sheet",
                badge: "DRAGGABLE DRAWER",
                desc: "Smooth velocity tracking, background dimming, and snapping detents (.collapsed, .half, .full).",
                badgeColor: .blue
            ) {
                VStack(spacing: 14) {
                    HStack(spacing: 8) {
                        ForEach([SheetDetent.collapsed, SheetDetent.half, SheetDetent.full], id: \.self) { det in
                            Button {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.75)) {
                                    sheetDetent = det
                                }
                            } label: {
                                Text(det == .collapsed ? "Collapsed" : det == .half ? "Half (50%)" : "Full (88%)")
                                    .font(.caption.bold())
                                    .foregroundColor(sheetDetent == det ? .white : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule().fill(sheetDetent == det ? Color.blue : Color.primary.opacity(0.06))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Button {
                        isCustomSheetOpen = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("Present Live Interactive Bottom Sheet")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .fullScreenCover(isPresented: $isCustomSheetOpen) {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .onTapGesture {
                        isCustomSheetOpen = false
                    }
                
                CustomBottomSheet(currentDetent: $sheetDetent) {
                    VStack(spacing: 16) {
                        Capsule().fill(Color.gray.opacity(0.4)).frame(width: 40, height: 5).padding(.top, 10)
                        
                        Text("Custom Bottom Sheet")
                            .font(.headline)
                        
                        Text("Currently at \(sheetDetent == .collapsed ? "Collapsed" : sheetDetent == .half ? "Half Screen" : "Full Screen") position.")
                            .font(.caption).foregroundColor(.secondary)
                        
                        Divider()
                        
                        HStack {
                            Text("Flick down quickly to dismiss or drag handle.")
                                .font(.caption).foregroundColor(.secondary)
                            Spacer()
                            Button("Close") {
                                isCustomSheetOpen = false
                            }
                            .font(.caption.bold())
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - 4. Backgrounds Showcase
    
    private var backgroundsShowcase: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "3 Live Animated Backgrounds",
                desc: "High-performance procedural backgrounds: fluid chromatic aurora, drifting soft bokeh orbs, and 60fps canvas starfield."
            )
            
            Picker("Background", selection: $selectedBackground) {
                Text("Aurora Mesh").tag(0)
                Text("Bokeh Orbs").tag(1)
                Text("Starfield").tag(2)
            }
            .pickerStyle(.segmented)
            
            // Foreground Card
            VStack(spacing: 14) {
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                Text("Procedural Canvas Running")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("These background shaders and physics particles render at 60 FPS while keeping CPU usage minimal.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .padding(.top, 40)
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
    
    private func controlCard<Content: View>(
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
