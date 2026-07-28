// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AIAvatar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AIAvatar",
            targets: ["AIAvatar"]
        )
    ],
    targets: [
        .target(
            name: "AIAvatar",
            path: "Sources/AIAvatar"
        ),
        .testTarget(
            name: "AIAvatarTests",
            dependencies: ["AIAvatar"],
            path: "Tests/AIAvatarTests"
        )
    ]
)
