// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(name: "PerfectHTTPServer", url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.23"),
        .package(name: "PerfectSQLite", url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", from: "5.0.0"),
        .package(name: "PerfectSessionSQLite", url: "https://github.com/PerfectlySoft/Perfect-Session-SQLite.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: ["PerfectHTTPServer", "PerfectSQLite", "PerfectSessionSQLite"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["Server"]),
    ]
)
