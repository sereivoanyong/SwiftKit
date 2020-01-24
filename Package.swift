// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "SwiftKit",
  platforms: [.iOS(.v9)],
  products: [
    .library(name: "SwiftKit", targets: ["SwiftKit"]),
  ],
  targets: [
    .target(name: "SwiftKit", dependencies: []),
  ],
  swiftLanguageVersions: [.v5]
)
