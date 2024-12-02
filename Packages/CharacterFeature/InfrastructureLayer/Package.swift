// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InfrastructureLayer",
  platforms: [
    .iOS(.v14),
    .macOS(.v12)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "InfrastructureLayer",
      targets: ["InfrastructureLayer"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/OAuthSwift/OAuthSwift.git", from: "2.2.0"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
    .package(url: "https://github.com/ParableHealth/URLRequestBuilder.git", from: "0.0.2"),
    .package(path: "../CharacterFeature/DomainLayer")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "InfrastructureLayer",
      dependencies: [
        "OAuthSwift",
        .product(name: "KeychainSwift", package: "keychain-swift"),
        "URLRequestBuilder",
        "DomainLayer"
      ]
    ),
    .testTarget(
      name: "InfrastructureLayerTests",
      dependencies: ["InfrastructureLayer"]
    )
  ]
)
