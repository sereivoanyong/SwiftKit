// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "SwiftKit",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "SwiftKit", targets: ["SwiftKit"]),
    .library(name: "PropertyWrapperKit", targets: ["PropertyWrapperKit"]),
    .library(name: "RealmUtilities", targets: ["RealmUtilities"]),
    .library(name: "UIKitUtilities", targets: ["UIKitUtilities"]),
    .library(name: "WebKitUtilities", targets: ["WebKitUtilities"])
  ],
  dependencies: [
    .package(url: "https://github.com/realm/realm-swift", .upToNextMajor(from: "10.45.2"))
  ],
  targets: [
    .target(name: "SwiftKit", dependencies: []),
    .target(name: "PropertyWrapperKit", dependencies: ["SwiftKit"]),
    .target(name: "RealmUtilities", dependencies: [.product(name: "RealmSwift", package: "realm-swift"), "UIKitUtilities"]),
    .target(name: "UIKitUtilities", dependencies: ["SwiftKit"]),
    .target(name: "WebKitUtilities", dependencies: ["SwiftKit"]),
    .testTarget(name: "SwiftKitTests", dependencies: ["SwiftKit"]),
    .testTarget(name: "PropertyWrapperKitTests", dependencies: ["PropertyWrapperKit"]),
    .testTarget(name: "UIKitUtilitiesTests", dependencies: ["UIKitUtilities"])
  ]
)
