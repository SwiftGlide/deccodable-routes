// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "DecodableRouting",
  products: [
    .library(name: "DecodableRouting", targets: ["DecodableRouting"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kaishin/glide", from: "0.0.6"),
  ],
  targets: [
    .target(
      name: "DecodableRouting",
      dependencies: [
        .product(name: "Glide", package: "glide"),
    ]),
    .testTarget(
      name: "DecodableRoutingTests",
      dependencies: [
        .target(name: "DecodableRouting"),
    ]),
  ]
)
