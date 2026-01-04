// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "TripPlannerKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "TripPlannerKit", targets: ["TripPlannerKit"]),
    ],
    targets: [
        .target(
            name: "TripPlannerKit",
            path: "Sources/TripPlannerKit"
        ),
        .testTarget(
            name: "TripPlannerKitTests",
            dependencies: ["TripPlannerKit"],
            path: "Tests/TripPlannerKitTests"
        ),
    ]
)
