// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "RideSharedServer",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0"),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "7.0.0"),
        .package(url: "https://github.com/Kitura/Swift-SMTP", from: "5.1.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.1.1"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "MongoKitten", package: "MongoKitten"),
                .product(name: "SwiftSMTP", package: "Swift-SMTP"),
                .product(name: "Starscream", package: "Starscream"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
