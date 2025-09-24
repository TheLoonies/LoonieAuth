// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LoonieAuth",
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: [
    .library(name: "LoonieAuth", targets: ["LoonieAuth"])
  ],
  dependencies: [
    .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "LoonieAuth",
      dependencies: [
        .product(name: "Supabase", package: "supabase-swift")
      ]
    )
  ]
)
