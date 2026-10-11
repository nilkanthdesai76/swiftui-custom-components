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
}
