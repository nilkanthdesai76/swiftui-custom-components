import SwiftUI
import SwiftUICustomComponents

public enum ComponentCategory: String, CaseIterable, Identifiable {
    case tabBars = "Tab Bars (5)"
    case transitions = "Transitions (4)"
    case controls = "Controls (9)"
    case backgrounds = "Backgrounds (3)"
    
    public var id: String { rawValue }
}

public struct ShowcaseGalleryView: View {
    @State private var selectedCategory: ComponentCategory = .tabBars
    
    // Tab Bar State
    @State private var selectedTabBarStyle: Int = 0
    @State private var activeTabId: String = "home"
    
    // Navigation State
    @State private var selectedHeroCard: HeroCardItem? = nil
    @State private var isRipplePresented: Bool = false
    @State private var isCubeFlipped: Bool = false
    @State private var isSheetStackPresented: Bool = false
    
    // Controls State
    @State private var sheetDetent: SheetDetent = .half
    @State private var sliderValue: Double = 65
    @State private var steppedSliderValue: Int = 2
    @State private var isNightTheme: Bool = false
    @State private var isAppLocked: Bool = true
    @State private var isLiquidSwitchOn: Bool = true
    @State private var liquidConfirmedText: String = "Hold to Confirm"
    @State private var burstCount: Int = 0
    
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
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("SwiftUI Component Kit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - 1. Tab Bars Showcase
    
    private var tabBarsShowcase: some View {
        VStack(spacing: 20) {
            headerCard(
                title: "5 Unique Animated Tab Bars",
                desc: "Switch between custom bottom navigation bars with elastic springs, curved hero buttons, and glowing trackers."
            )
            
            // Tab Bar Style Selector
            Picker("Style", selection: $selectedTabBarStyle) {
                Text("Liquid Elastic").tag(0)
                Text("Curved Hero").tag(1)
                Text("Glow Line").tag(2)
                Text("Expanding").tag(3)
                Text("Floating Bubble").tag(4)
            }
            .pickerStyle(.segmented)
            
            // Live Tab Content Mock
            VStack(spacing: 12) {
                Image(systemName: sampleTabs.first(where: { $0.id == activeTabId })?.icon ?? "house")
                    .font(.system(size: 44))
                    .foregroundColor(.accentColor)
                    .padding(.top, 24)
                
                Text("Active Tab: \(activeTabId.capitalized)")
                    .font(.system(size: 18, weight: .bold))
                
                Text("Tap the tab items below to observe liquid morphing, haptic bursts, and spring physics.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.appSecondarySystemBackground)
            )
            
            // Render Selected Tab Bar
            VStack(spacing: 8) {
                Text("LIVE INTERACTIVE TAB BAR")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                switch selectedTabBarStyle {
                case 0:
                    LiquidElasticTabBar(items: sampleTabs, selectedTabId: $activeTabId, accentColor: .blue)
                case 1:
                    CurvedNotchHeroTabBar(
                        leftItems: Array(sampleTabs.prefix(2)),
                        rightItems: Array(sampleTabs.suffix(2)),
                        selectedTabId: $activeTabId,
                        heroIcon: "plus",
                        heroColor: .purple,
                        onHeroAction: {
                            HapticFeedback.success()
                        }
                    )
                case 2:
                    MorphingLineTabBar(items: sampleTabs, selectedTabId: $activeTabId, accentColor: .cyan, linePosition: .top)
                case 3:
                    ExpandingLabelTabBar(items: sampleTabs, selectedTabId: $activeTabId, accentColor: .purple)
                case 4:
                    FloatingBubbleTabBar(items: sampleTabs, selectedTabId: $activeTabId, accentColor: .pink)
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
                title: "4 Interactive Transitions",
                desc: "Experience gesture-driven hero zoom expansions, circular focal ripple reveals, 3D cube turnover, and depth sheet stacks."
            )
            
            // A. Hero Card Transition
            VStack(alignment: .leading, spacing: 10) {
                Text("1. APP STORE HERO EXPANSION")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                HeroCardContainerView(cards: sampleHeroCards, selectedCard: $selectedHeroCard)
                    .frame(height: 320)
            }
            
            Divider()
            
            // B. Circular Ripple Transition
            VStack(alignment: .leading, spacing: 12) {
                Text("2. CIRCULAR FOCAL RIPPLE REVEAL")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                CircularRippleTransitionView(
                    isPresented: $isRipplePresented,
                    content: {
                        Button {
                            isRipplePresented = true
                        } label: {
                            HStack {
                                Image(systemName: "circle.circle.fill")
                                Text("Trigger Circular Mask Reveal")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.purple.opacity(0.15)))
                        }
                        .buttonStyle(.plain)
                    },
                    destination: {
                        ZStack {
                            Color.purple.ignoresSafeArea()
                            VStack(spacing: 16) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                Text("Destination Screen")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                Text("Revealed expanding from focal tap point!")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Button("Close Destination") {
                                    isRipplePresented = false
                                }
                                .font(.headline)
                                .foregroundColor(.purple)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(.white))
                                .padding(.top, 20)
                            }
                        }
                    }
                )
            }
            
            Divider()
            
            // C. 3D Spatial Cube Turnover
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("3. 3D SPATIAL CUBE TURNOVER")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(isCubeFlipped ? "Flip Back" : "Flip Cube") {
                        HapticFeedback.medium()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            isCubeFlipped.toggle()
                        }
                    }
                    .font(.system(size: 12, weight: .bold))
                }
                
                Spatial3DCubeTransitionView(
                    isRotatedToB: $isCubeFlipped,
                    viewA: {
                        cubeFace(title: "Front Face (Screen A)", color: .blue, icon: "cube.fill")
                    },
                    viewB: {
                        cubeFace(title: "Side Face (Screen B)", color: .pink, icon: "cube.transparent")
                    }
                )
                .frame(height: 160)
            }
            
            Divider()
            
            // D. Sheet Stack
            VStack(alignment: .leading, spacing: 12) {
                Text("4. STACKED CARD DEPTH SHEET")
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
    
    // MARK: - 3. Controls Showcase
    
    private var controlsShowcase: some View {
        VStack(spacing: 22) {
            headerCard(
                title: "9 Custom UI Controls",
                desc: "Micro-interactions engineered for delight: hold-to-confirm, confetti burst, 3D buttons, elastic sliders, and image switches."
            )
            
            // A. Animated Buttons
            VStack(alignment: .leading, spacing: 14) {
                Text("ANIMATED BUTTONS")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                ShimmerPulseButton(title: "Shimmer Sweep Action", icon: "sparkles") {}
                
                LiquidFillProgressButton(
                    title: "Hold 1.2s to Confirm",
                    completedTitle: "Action Deployed!",
                    fillColor: .green
                ) {}
                
                ParticleBurstButton(title: "Celebrate with Confetti Burst", icon: "heart.fill", tintColor: .pink) {
                    burstCount += 1
                }
                
                Tactile3DButton(title: "Tactile 3D Physical Push", icon: "cube.fill") {}
            }
            
            Divider()
            
            // B. Sliders
            VStack(alignment: .leading, spacing: 14) {
                Text("ELASTIC & HAPTIC SLIDERS")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Text("Elastic Bubble Slider (\(Int(sliderValue))%)")
                    .font(.subheadline.bold())
                ElasticBubbleSlider(value: $sliderValue)
                
                Text("Stepped Haptic Tick Slider (Step \(steppedSliderValue + 1) of 5)")
                    .font(.subheadline.bold())
                    .padding(.top, 10)
                SteppedHapticTickSlider(currentStep: $steppedSliderValue, totalSteps: 5)
            }
            
            Divider()
            
            // C. Switches
            VStack(alignment: .leading, spacing: 14) {
                Text("IMAGE & ICON SWITCHES")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Day / Night Celestial Switch")
                            .font(.system(size: 14, weight: .bold))
                        Text(isNightTheme ? "Midnight Moon & Stars" : "Warm Sun & Clouds")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    DayNightThemeSwitch(isNight: $isNightTheme)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Padlock Security Switch")
                            .font(.system(size: 14, weight: .bold))
                        Text(isAppLocked ? "Encrypted & Locked" : "Biometrics Unlocked")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    LockUnlockSwitch(isLocked: $isAppLocked)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Liquid Stretch Toggle")
                            .font(.system(size: 14, weight: .bold))
                        Text(isLiquidSwitchOn ? "Viscous Liquid Active" : "Disabled")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    LiquidStretchSwitch(isOn: $isLiquidSwitchOn, onColor: .purple)
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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            Text(desc)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.appSecondarySystemBackground)
        )
    }
}

#Preview {
    ShowcaseGalleryView()
}
