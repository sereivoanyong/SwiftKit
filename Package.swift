// swift-tools-version:5.10

import PackageDescription

let package = Package(
  name: "SwiftKit",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    .library(name: "SwiftKit", targets: ["SwiftKit"]),
    .library(name: "PropertyWrapperKit", targets: ["PropertyWrapperKit", "SwiftKit"]),
    .library(name: "UIKitUtilities", targets: ["UIKitUtilities", "SwiftKit"]),
    .library(name: "WebKitUtilities", targets: ["WebKitUtilities", "SwiftKit"]),
  ],
  targets: [
    .target(name: "SwiftKit", dependencies: []),
    .target(name: "PropertyWrapperKit", dependencies: ["SwiftKit"]),
    .target(name: "UIKitUtilities", dependencies: ["SwiftKit"]),
    .target(name: "WebKitUtilities", dependencies: ["SwiftKit"]),
    .testTarget(name: "SwiftKitTests", dependencies: ["SwiftKit"]),
    .testTarget(name: "PropertyWrapperKitTests", dependencies: ["PropertyWrapperKit"]),
    .testTarget(name: "UIKitUtilitiesTests", dependencies: ["UIKitUtilities"]),
  ]
)
