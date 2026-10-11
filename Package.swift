// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftUICustomComponents",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUICustomComponents",
            targets: ["SwiftUICustomComponents"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUICustomComponents",
            dependencies: [],
            path: "Sources/SwiftUICustomComponents"
        ),
        .testTarget(
            name: "SwiftUICustomComponentsTests",
            dependencies: ["SwiftUICustomComponents"],
            path: "Tests/SwiftUICustomComponentsTests"
        ),
    ]
)
