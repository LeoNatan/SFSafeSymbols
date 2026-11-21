// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS(.v12), .tvOS(.v12), .watchOS(.v5), .macOS(.v10_14), .visionOS(.v1)],
    products: [
        .library(name: "SFSafeSymbols", targets: ["SFSafeSymbols"]),
        // Symbols of the system's private catalog. It uses private API to create their images.
        .library(name: "SFSafeSymbolsPrivate", targets: ["SFSafeSymbolsPrivate"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SFSafeSymbols",
            dependencies: [],
            exclude: ["SymbolImages"]
        ),
        .target(
            name: "SFSafeSymbolsPrivate",
            dependencies: ["SFSafeSymbols"],
            exclude: ["SymbolImages"]
        ),
        .testTarget(
            name: "SFSafeSymbolsTests",
            dependencies: ["SFSafeSymbols"]
        ),
        .testTarget(
            name: "SFSafeSymbolsPrivateTests",
            dependencies: ["SFSafeSymbolsPrivate"]
        )
    ]
)
