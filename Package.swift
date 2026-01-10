// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibNFCSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibNFCSwift",
            targets: ["LibNFCSwift"]
        )        
    ],
    targets: [
        .target(
            name: "LibNFCSwift",
            dependencies: [
                .byName(name: "Clibnfc")
            ]
        ),
        .systemLibrary(
            name: "Clibnfc",
            pkgConfig: "libnfc",
            providers: [
                .brew(["libnfc"]),
                .apt(["libnfc-dev"])
            ]
        )
    ]
)
