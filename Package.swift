// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "KeyChaining",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
	],
    products: [
        .library(name: "KeyChaining", targets: ["KeyChaining"]),
    ],
    dependencies: [],
    targets: [
        .target(
			name: "KeyChaining",
			dependencies: [],
			/// Swift compiler settings for Release configuration.
			swiftSettings: swiftSettings,
		),
        .testTarget(name: "KeyChainingTests", dependencies: ["KeyChaining"]),
    ]
)

/// Swift compiler settings for Release configuration.
var swiftSettings: [SwiftSetting] { [
	// Enable maximum optimizations in release
	.unsafeFlags(["-O"], .when(configuration: .release)),
	// "ExistentialAny" is an option that makes the use of the `any` keyword for existential types `required`
	.enableUpcomingFeature("ExistentialAny")
] }
