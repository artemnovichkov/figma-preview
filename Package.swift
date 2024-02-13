// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FigmaPreview",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FigmaPreview",
            targets: ["FigmaPreview"]),
    ],
    targets: [
        .target(
            name: "FigmaPreview"),
    ]
)
