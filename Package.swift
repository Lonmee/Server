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
        .package(name: "PerfectWebRedirects", url: "https://github.com/PerfectlySoft/Perfect-WebRedirects", from: "3.0.1"),
        .package(name: "PerfectSession", url: "https://github.com/PerfectlySoft/Perfect-Session.git", from: "3.1.5"),
        .package(name: "PerfectSQLite", url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", from: "5.0.0"),
        .package(name: "OAuth2", url: "https://github.com/PerfectlySoft/Perfect-OAuth2.git", from: "3.0.6"),
//        .package(name: "SQLiteStORM", url: "https://github.com/SwiftORM/SQLite-StORM.git", from: "3.1.0"),
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: ["PerfectHTTPServer", "PerfectWebRedirects", "PerfectSession", "PerfectSQLite", "OAuth2"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["Server"]),
    ]
)
