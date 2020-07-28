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
        .package(path: "../../frameworks/UberSegmentedControl"),
    ],
    targets: [
        .target(
            name: "TransformationsUIShared",
            dependencies: ["UberSegmentedControl"]
        ),
    ]
)
