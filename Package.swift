// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TimerKit",
    platforms: [
         .iOS(.v13)//, .macOS(.v10_13), .watchOS(.v4), .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TimerKit",
            targets: ["TimerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bretsko/DateKit", from: "7.0.0"),
        .package(url: "https://github.com/bretsko/Quick", from: "2.2.1"),
        .package(url: "https://github.com/bretsko/Log", from: "1.0.0"),
        //.package(url: "https://github.com/bretsko/MinimalBase", from: "1.0.0"),
        //.package(url: "https://github.com/bretsko/Nimble", from: "8.0.5"),
    ],
    targets: [
        .target(
            name: "TimerKit",
            dependencies: ["DateKit",
                           "Log"]),

        .testTarget(
            name: "TimerKitTests",
            dependencies: ["TimerKit", "Quick"]),
    ],
    swiftLanguageVersions: [.v5]
)
