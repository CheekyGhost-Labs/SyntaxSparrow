// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SyntaxSparrow",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SyntaxSparrow",
            targets: ["SyntaxSparrow"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: Version("508.0.0")),
    ],
    targets: [
        .target(
            name: "SyntaxSparrow",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax")
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
