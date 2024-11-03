// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTPKit",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12), .watchOS(.v8), .tvOS(.v15), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HTTPKit",
            targets: ["HTTPKit"]
        ),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HTTPKit",
            dependencies: [],
            path: "Sources",
            exclude: [],
            swiftSettings: [
//                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTPKit"],
            path: "Tests"
        ),
    ]
)
