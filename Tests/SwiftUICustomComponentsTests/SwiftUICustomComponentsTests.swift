import XCTest
@testable import SwiftUICustomComponents

final class SwiftUICustomComponentsTests: XCTestCase {
    
    func testTabBarItemModel() {
        let item = TabBarItem(id: "home", title: "Feed", icon: "house", activeIcon: "house.fill", badgeCount: 5)
        XCTAssertEqual(item.id, "home")
        XCTAssertEqual(item.title, "Feed")
        XCTAssertEqual(item.icon, "house")
        XCTAssertEqual(item.activeIcon, "house.fill")
        XCTAssertEqual(item.badgeCount, 5)
    }
    
    func testHeroCardItemModel() {
        let card = HeroCardItem(
            id: "card-1",
            title: "Motion Design",
            subtitle: "Fluid Physics",
            category: "Architecture"
        )
        XCTAssertEqual(card.id, "card-1")
        XCTAssertEqual(card.title, "Motion Design")
        XCTAssertEqual(card.subtitle, "Fluid Physics")
        XCTAssertEqual(card.category, "Architecture")
    }
    
    func testSheetDetents() {
        XCTAssertEqual(SheetDetent.collapsed.rawValue, 100)
        XCTAssertEqual(SheetDetent.half.rawValue, 380)
        XCTAssertEqual(SheetDetent.full.rawValue, 680)
    }
    
    func testButtonActionState() {
        let idle = ButtonActionState.idle
        let loading = ButtonActionState.loading
        let success = ButtonActionState.success
        let error = ButtonActionState.error
        
        XCTAssertNotEqual(idle, loading)
        XCTAssertNotEqual(loading, success)
        XCTAssertNotEqual(success, error)
    }
    
    func testSegmentItemModel() {
        let item = SegmentItem(id: "weekly", title: "Weekly", icon: "flame.fill")
        XCTAssertEqual(item.id, "weekly")
        XCTAssertEqual(item.title, "Weekly")
        XCTAssertEqual(item.icon, "flame.fill")
    }
    
    func testTagItemModel() {
        let tag = TagItem(id: "swiftui", name: "SwiftUI", icon: "swift")
        XCTAssertEqual(tag.id, "swiftui")
        XCTAssertEqual(tag.name, "SwiftUI")
        XCTAssertEqual(tag.icon, "swift")
    }
    
    func testHapticFeedbackExecution() {
        // Ensure haptics execute cleanly without crashing on test environment
        HapticFeedback.selection()
        HapticFeedback.light()
        HapticFeedback.medium()
        HapticFeedback.heavy()
        HapticFeedback.success()
        HapticFeedback.warning()
        HapticFeedback.error()
    }
    
    func testColorSwatchItemModel() {
        let swatch = ColorSwatchItem(id: "blue", name: "Electric Blue", color: .blue, hexCode: "#007AFF")
        XCTAssertEqual(swatch.id, "blue")
        XCTAssertEqual(swatch.name, "Electric Blue")
        XCTAssertEqual(swatch.hexCode, "#007AFF")
    }
}
