// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreNetworking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CoreNetworking",
            targets: ["CoreNetworking"]
        ),
    ],
    targets: [
        .target(
            name: "CoreNetworking"
        ),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: ["CoreNetworking"]
        ),
    ]
)
