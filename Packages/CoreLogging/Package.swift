// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreLogging",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "CoreLogging", targets: ["CoreLogging"]),
    ],
    targets: [
        .target(name: "CoreLogging"),
        .testTarget(name: "CoreLoggingTests", dependencies: ["CoreLogging"])
    ]
)
