// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TimerKit",
    platforms: [
         .iOS(.v13)//, .watchOS(.v4), .tvOS(.v10), .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TimerKit",
            targets: ["TimerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bretsko/Quick", from: "2.2.1"),
        .package(url: "https://github.com/bretsko/Nimble", from: "8.0.5"),
        .package(url: "https://github.com/bretsko/Logger", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TimerKit",
            dependencies: ["Quick",
                           "Nimble",
                           "Log"]),

        .testTarget(
            name: "TimerKitTests",
            dependencies: ["TimerKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
