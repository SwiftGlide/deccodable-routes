// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "decodable-routes",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "DecodableRoutes", targets: ["DecodableRoutes"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SwiftGlide/glide.git", .branch("master")),
    .package(url: "https://github.com/SwiftGlide/query-string-coder.git", .branch("master")),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-nio", from: "2.12.0")
  ],
  targets: [
    .target(
      name: "DecodableRoutes",
      dependencies: [
        .product(name: "Glide", package: "glide"),
        .product(name: "QueryStringCoder", package: "query-string-coder"),

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
