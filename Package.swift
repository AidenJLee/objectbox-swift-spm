// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// API reference: https://developer.apple.com/documentation/packagedescription/package

import Foundation
import PackageDescription

let version = "4.2.0"
let checksumObjectBox = "7081ab867037de8fc58dfa8f18a0a87fd0a10cdeae66d580c78e086d9bec6156"
let checksumObjectBoxGenerator = "003d51095ded2e025fbed2b8eebe516f8a65b73cd2120a9cd56e04988cc19a22"

let package = Package(
  name: "ObjectBox",
  platforms: [
    // This should match the requirements of ObjectBox.xcframework (so the ObjectBox Swift API and native libraries)
    .macOS(.v10_15), .iOS(.v12),
  ],
  products: [
    .plugin(name: "ObjectBoxPlugin", targets: ["ObjectBoxGeneratorCommand"]),
    .library(name: "ObjectBox.xcframework", targets: ["ObjectBox.xcframework"]),
  ],
  targets: [

    /// MARK: - Binary dependencies
    .binaryTarget(
      name: "ObjectBoxGenerator",
      url:
        "https://github.com/objectbox/objectbox-swift-spec-staging/releases/download/v4.0.2-rc2/ObjectBoxGenerator.artifactbundle.zip",
      checksum: checksumObjectBoxGenerator
    ),
    .binaryTarget(
      name: "ObjectBox.xcframework",
      url:
        "https://github.com/objectbox/objectbox-swift/releases/download/v4.2.0/ObjectBox-xcframework-4.2.0.zip",
      checksum: checksumObjectBox
    ),

    /// MARK: - Plugin implementations
    .plugin(
      name: "ObjectBoxGeneratorCommand",
      capability: .command(
        intent: .custom(
          verb: "objectbox-generator",  // users will call like 'swift package plugin <verb>'
          description: "Runs the ObjectBox code generator"
        ),
        permissions: [
          .writeToPackageDirectory(reason: "Generate files in the package directory")
        ]
      ),
      dependencies: [
        .target(name: "ObjectBoxGenerator")
      ],
      path: "Plugins/GeneratorCommand"
    ),

  ]
)
