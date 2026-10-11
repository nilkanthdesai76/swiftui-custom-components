# SwiftUI Custom Components 🎨✨

[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2016%2B%20%7C%20macOS%2013%2B-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI](https://github.com/nilkanthdesai76/swiftui-custom-components/actions/workflows/ci.yml/badge.svg)](https://github.com/nilkanthdesai76/swiftui-custom-components/actions)

A curated collection of production-ready, micro-animated SwiftUI components designed to bring tactile physics, fluid spatial transitions, custom bottom navigation docks, and procedural live backgrounds to iOS and macOS apps.

---

## 🌟 Features Overview

```
SwiftUICustomComponents
├── 📱 Tab Bars (5 Styles)
│   ├── LiquidElasticTabBar       — Spring-fluid capsule pill dock
│   ├── CurvedNotchHeroTabBar     — Bezier curved notch with floating action
│   ├── MorphingLineTabBar        — Minimalist glowing neon tracker
│   ├── ExpandingLabelTabBar      — Airbnb/Pinterest style capsule expansion
│   └── FloatingBubbleTabBar      — Frosted glass isolated bubble dock
│
├── 🚀 Custom Navigation Transitions (4 Styles)
│   ├── HeroCardTransition        — App Store Today card zoom & drag-to-dismiss
│   ├── CircularRippleTransition  — Radial circular mask reveal from tap point
│   ├── Spatial3DCubeTransition   — 3D perspective cube rotation
│   └── SheetStackTransition      — Multi-layer card depth scaling
│
├── 🎛️ Custom Controls & Micro-Interactions (10 Components)
│   ├── CustomBottomSheet         — Snapping multi-detent sheet with flick gesture
│   ├── ShimmerPulseButton        — 45° continuous light sweep button
│   ├── LiquidFillProgressButton  — Hold-to-confirm rising wave fill (1.2s)
│   ├── ParticleBurstButton       — Radial confetti particle burst
│   ├── Tactile3DButton           — Realistic 3D bevel depth depression
│   ├── ElasticBubbleSlider       — Dynamic velocity-stretched tooltip slider
│   ├── SteppedHapticTickSlider   — Discrete notched slider with tick haptics
│   ├── DayNightThemeSwitch       — Celestial rotating Sun & Cratered Moon switch
│   ├── LockUnlockSwitch          — Animated shackle security padlock toggle
│   └── LiquidStretchSwitch       — Viscous fluid stretching thumb toggle
│
└── 🌌 Live Procedural Backgrounds (3 Views)
    ├── AuroraMeshGradientView    — Shifting multi-point northern lights gradient
    ├── FloatingBokehOrbsView     — Soft ambient floating luminous orbs
    └── StarfieldParticlesView    — 60fps Canvas-rendered deep space dust & stars
```

---

## 📦 Installation

### Swift Package Manager (SPM)

In Xcode, select **File → Add Package Dependencies...** and enter:

```
https://github.com/nilkanthdesai76/swiftui-custom-components.git
```

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nilkanthdesai76/swiftui-custom-components.git", from: "1.0.0")
]
```

---

## 🚀 Quick Start & Usage Examples

### 1. Animated Tab Bars

```swift
import SwiftUI
import SwiftUICustomComponents

struct ContentView: View {
    @State private var selectedTab = "home"
    
    let tabs = [
        TabBarItem(id: "home", title: "Feed", icon: "house", activeIcon: "house.fill"),
        TabBarItem(id: "search", title: "Explore", icon: "magnifyingglass"),
        TabBarItem(id: "alerts", title: "Alerts", icon: "bell", activeIcon: "bell.fill", badgeCount: 3),
        TabBarItem(id: "profile", title: "Profile", icon: "person", activeIcon: "person.fill")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Screen content
            TabView(selection: $selectedTab) { ... }
            
            // Choose your dock style:
            LiquidElasticTabBar(items: tabs, selectedId: $selectedTab)
            // or: CurvedNotchHeroTabBar(items: tabs, selectedId: $selectedTab) { heroAction() }
            // or: MorphingLineTabBar(items: tabs, selectedId: $selectedTab)
            // or: ExpandingLabelTabBar(items: tabs, selectedId: $selectedTab)
            // or: FloatingBubbleTabBar(items: tabs, selectedId: $selectedTab)
        }
    }
}
```

---

### 2. Custom Navigation Transitions

#### Hero Card Zoom (App Store Style)

```swift
@Namespace private var animationNamespace
@State private var selectedItem: HeroCardItem? = nil

ZStack {
    ScrollView {
        HeroCardSourceView(item: cardItem, namespace: animationNamespace) {
            selectedItem = cardItem
        }
    }
    
    if let item = selectedItem {
        HeroCardDestinationView(
            item: item,
            namespace: animationNamespace,
            onDismiss: { selectedItem = nil }
        ) {
            // Full article content
        }
    }
}
```

#### Circular Ripple Mask Transition

```swift
@State private var showDetail = false
@State private var tapPosition = CGPoint(x: 200, y: 400)

DetailView()
    .circularRipple(isPresented: showDetail, center: tapPosition)
```

#### Spatial 3D Cube Rotation

```swift
@State private var isFlipped = false

ZStack {
    FrontView()
        .spatial3DCube(isPresented: isFlipped, isFront: true)
    
    BackView()
        .spatial3DCube(isPresented: isFlipped, isFront: false)
}
```

---

### 3. Custom UI Controls & Micro-Interactions

#### Hold-to-Confirm Liquid Fill Button

```swift
LiquidFillProgressButton(
    title: "Hold to Confirm Payment",
    fillColor: .green,
    duration: 1.2
) {
    // Action triggered only after full 1.2s hold
    processCheckout()
}
```

#### Particle Confetti Burst Button

```swift
ParticleBurstButton(
    title: "Celebrate Milestone",
    icon: "sparkles",
    gradientColors: [.pink, .orange]
) {
    // Fires 8 radial exploding particles with spring physics
}
```

#### Elastic Bubble Slider

```swift
@State private var volume: Double = 75

ElasticBubbleSlider(
    value: $volume,
    range: 0...100,
    accentColor: .blue,
    formatter: { "\(Int($0))%" }
)
```

#### Celestial Day/Night Theme Switch

```swift
@State private var isDark = false

DayNightThemeSwitch(isOn: $isDark)
```

#### Security Padlock Switch

```swift
@State private var isLocked = true

LockUnlockSwitch(isLocked: $isLocked)
```

#### Multi-Detent Bottom Sheet

```swift
@State private var sheetDetent: SheetDetent = .half

CustomBottomSheet(currentDetent: $sheetDetent) {
    VStack {
        Text("Sheet Content")
    }
}
```

---

### 4. Procedural Live Backgrounds

```swift
ZStack {
    // Dynamic flowing aurora
    AuroraMeshGradientView()
        .ignoresSafeArea()
    
    // or: FloatingBokehOrbsView(orbCount: 6)
    // or: StarfieldParticlesView(starCount: 120)
    
    VStack {
        Text("Welcome to Notchy")
    }
}
```

---

## 📱 Running the Showcase Project

The repository includes a complete, standalone iOS showcase app so you can interact with all components live in the Simulator or on device:

```sh
cd Showcase
xcodebuild -project Showcase.xcodeproj -scheme Showcase -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Or open `Showcase/Showcase.xcodeproj` in Xcode 16+ and hit **Cmd + R**.

---

## 🧪 Testing

Run package unit tests via terminal:

```sh
swift test
```

---

## 📄 License

This library is released under the **MIT License**. See [LICENSE](LICENSE) for details.
