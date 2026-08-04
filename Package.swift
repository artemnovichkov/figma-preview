// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

#if compiler(>=6.3)
let swiftSyntaxVersion: Version = "603.0.0"
#elseif compiler(>=6.2)
let swiftSyntaxVersion: Version = "602.0.0"
#elseif compiler(>=6.1)
let swiftSyntaxVersion: Version = "601.0.0"
#elseif compiler(>=6.0)
let swiftSyntaxVersion: Version = "600.0.0"
#else
let swiftSyntaxVersion: Version = "510.0.0"
#endif

let package = Package(
    name: "FigmaPreview",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "FigmaPreview",
            targets: ["FigmaPreview"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: swiftSyntaxVersion),
    ],
    targets: [
        .macro(
            name: "FigmaPreviewMacros",
            dependencies: [
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]),
        .target(
            name: "FigmaPreview",
            dependencies: ["FigmaPreviewMacros"]),
        .testTarget(
            name: "FigmaPreviewMacrosTests",
            dependencies: [
                "FigmaPreviewMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]),
    ]
)
