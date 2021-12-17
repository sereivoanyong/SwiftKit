// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "SwiftKit",
  platforms: [
    .iOS(.v9)
  ],
  products: [
    .library(name: "SwiftKit", targets: ["SwiftKit"]),
    .library(name: "PropertyWrapperKit", targets: ["PropertyWrapperKit"])
  ],
  targets: [
    .target(name: "SwiftKit"),
    .target(name: "PropertyWrapperKit", dependencies: ["SwiftKit"])
  ]
)
