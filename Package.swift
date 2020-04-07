// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "DecodableRouting",
  products: [
    .library(name: "DecodableRouting", targets: ["DecodableRouting"]),
  ],
  dependencies: [
    .package(path: "../glide"),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-nio", from: "2.12.0")
  ],
  targets: [
    .target(
      name: "DecodableRouting",
      dependencies: [
        "Glide"
    ]),
    .testTarget(
      name: "DecodableRoutingTests",
      dependencies: [
        "DecodableRouting",
        "AsyncHTTPClient",
        "NIO"
    ]),
  ]
)
