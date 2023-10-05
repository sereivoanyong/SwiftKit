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
    .library(name: "UIKitExtra", targets: ["UIKitExtra"]),
    .library(name: "WebKitExtra", targets: ["WebKitExtra"])
  ],
  targets: [
    .target(name: "SwiftKit", dependencies: []),
    .target(name: "PropertyWrapperKit", dependencies: ["SwiftKit"]),
    .target(name: "UIKitExtra", dependencies: ["SwiftKit"]),
    .target(name: "WebKitExtra", dependencies: ["SwiftKit"]),
    .testTarget(name: "SwiftKitTests", dependencies: ["SwiftKit"]),
    .testTarget(name: "PropertyWrapperKitTests", dependencies: ["PropertyWrapperKit"]),
    .testTarget(name: "UIKitExtraTests", dependencies: ["UIKitExtra"])
  ]
)
