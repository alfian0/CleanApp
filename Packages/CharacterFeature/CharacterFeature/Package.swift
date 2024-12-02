// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CharacterFeature",
  platforms: [
    .iOS(.v14),
    .macOS(.v12)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "CharacterFeature",
      targets: ["CharacterFeature"]
    )
  ],
  dependencies: [
    .package(path: "../DataLayer"),
    .package(path: "../DomainLayer"),
    .package(path: "../PresentationLayer")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "CharacterFeature",
      dependencies: [
        "DataLayer",
        "DomainLayer",
        "PresentationLayer"
      ]
    ),
    .testTarget(
      name: "CharacterFeatureTests",
      dependencies: ["CharacterFeature"]
    )
  ]
)
