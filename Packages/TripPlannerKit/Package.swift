// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TripPlannerKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TripPlannerKit",
            targets: ["TripPlannerKit"]
        ),
    ],
    dependencies: [
        // aquí irán dependencias futuras (por ejemplo, snapshots, etc.)
    ],
    targets: [
        .target(
            name: "TripPlannerKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "TripPlannerKitTests",
            dependencies: ["TripPlannerKit"],
            path: "Tests"
        ),
    ]
)
