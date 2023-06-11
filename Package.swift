// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SyntaxSparrow",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SyntaxSparrow",
            targets: ["SyntaxSparrow"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-06-05-a"),
    ],
    targets: [
        .target(
            name: "SyntaxSparrow",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "SyntaxSparrowTests",
            dependencies: [
                "SyntaxSparrow",
            ]
        ),
    ]
)

// Supplementary
package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/SwiftPackageIndex/SPIManifest.git", from: "0.12.0"),
])
