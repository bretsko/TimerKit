// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TimerKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v14) //, .watchOS(.v4), .tvOS(.v10)
    ],
    products: [
        .library(
            name: "TimerKit",
            targets: ["TimerKit"]),
    ],
    dependencies: [
        // .package(url: "../DateKit", .exact("1.0.0")),
        .package(url: "https://github.com/bretsko/DateKit", .exact("1.0.0")),
        
        //   .package(url: "../Quick/Quick", .exact("1.0.0")),
        // .package(url: "../Quick/Nimble", .exact("1.0.0")),
        .package(url: "https://github.com/bretsko/Quick", from: "2.2.1"),
        .package(url: "https://github.com/bretsko/Nimble", from: "8.0.5"),
    ],
    targets: [
        .target(
            name: "TimerKit",
            dependencies: ["DateKit"]),

        .testTarget(
            name: "TimerKitTests",
            dependencies: ["TimerKit", "Quick", "Nimble"]),
    ]
)
