// swift-tools-version:5.2
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
    .package(url: "https://github.com/SwiftGlide/glide.git", from: "0.3.0"),
    .package(url: "https://github.com/SwiftGlide/query-string-coder.git", from: "0.0.3"),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "DecodableRoutes",
      dependencies: [
        .product(name: "Glide", package: "glide"),
        .product(name: "QueryStringCoder", package: "query-string-coder")
      ]),
    .testTarget(
      name: "DecodableRoutesTests",
      dependencies: [
        .target(name: "DecodableRoutes"),
        .product(name: "AsyncHTTPClient", package: "async-http-client")
      ]),
  ]
)
