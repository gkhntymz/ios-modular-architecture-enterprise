// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FeatureAuthentication",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "FeatureAuthentication", targets: ["FeatureAuthentication"])
    ],
    dependencies: [
        .package(path: "../CoreNetworking")
    ],
    targets: [
        .target(
            name: "FeatureAuthentication",
            dependencies: [
                .product(name: "CoreNetworking", package: "CoreNetworking")
            ]
        ),
        .testTarget(
            name: "FeatureAuthenticationTests",
            dependencies: ["FeatureAuthentication"]
        )
    ]
)
