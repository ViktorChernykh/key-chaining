// swift-tools-version: 5.9
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
        .target(name: "KeyChaining", dependencies: []),
        .testTarget(name: "KeyChainingTests", dependencies: ["KeyChaining"]),
    ]
)
