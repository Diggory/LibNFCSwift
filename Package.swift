// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibNFCSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibNFCSwift",
            targets: ["LibNFCSwift"]
        ),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LibNFCSwift",
            dependencies: [
                .byName(name: "Clibnfc"),
            ],
//            swiftSettings: [
//                .unsafeFlags(["-I/opt/homebrew/include"], .when(platforms: [.macOS]))
//            ],
//            linkerSettings: [
//                .unsafeFlags(["-Xlinker", "-L/opt/homebrew/lib"], .when(platforms: [.macOS])),
//            ]

        ),
        .systemLibrary(
            name: "Clibnfc",
            pkgConfig: "libnfc",
            providers: [
                .brew(["libnfc"]),
                .apt(["libnfc"])
            ]
        )
    ]
)
