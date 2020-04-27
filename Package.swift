// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "DecodableRoutes",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "DecodableRoutes", targets: ["DecodableRoutes"]),
  ],
  dependencies: [
    .package(name: "Glide", url: "https://github.com/SwiftGlide/glide.git", .branch("master")),
    .package(name: "QueryStringCoder", url: "https://github.com/SwiftGlide/query-string-coder.git", .branch("master")),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-nio", from: "2.12.0")
  ],
  targets: [
    .target(
      name: "DecodableRoutes",
      dependencies: [
        .product(name: "Glide", package: "Glide"),
        .product(name: "QueryStringCoder", package: "QueryStringCoder"),

    ]),
    .testTarget(
      name: "DecodableRoutesTests",
      dependencies: [
        .target(name: "DecodableRoutes"),
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
        .product(name: "NIO", package: "swift-nio")
    ]),
  ]
)
