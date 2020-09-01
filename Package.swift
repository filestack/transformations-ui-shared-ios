// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransformationsUIShared",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "TransformationsUIShared",
            targets: ["TransformationsUIShared"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rnine/UberSegmentedControl.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "TransformationsUIShared",
            dependencies: ["UberSegmentedControl"]
        ),
    ]
)
