import Foundation

public struct MockPlacesRepository: PlacesRepository {
    public init() {}

    public func topPlaces(for destination: String) async throws -> [POI] {
        // Mock simple. Luego sustituimos por API real.
        return [
            POI(id: "1", name: "\(destination) Old Town Walk", category: .neighborhood,
                coordinate: .init(latitude: 41.0, longitude: 2.0), score: 0.9),
            POI(id: "2", name: "Main Landmark", category: .landmark,
                coordinate: .init(latitude: 41.1, longitude: 2.1), score: 0.95),
            POI(id: "3", name: "City Museum", category: .museum,
                coordinate: .init(latitude: 41.2, longitude: 2.05), score: 0.85),
            POI(id: "4", name: "Central Park", category: .park,
                coordinate: .init(latitude: 41.05, longitude: 2.2), score: 0.8),
            POI(id: "5", name: "Viewpoint Sunset", category: .viewpoint,
                coordinate: .init(latitude: 41.12, longitude: 2.15), score: 0.88),
            POI(id: "6", name: "Local Food Market", category: .food,
                coordinate: .init(latitude: 41.08, longitude: 2.07), score: 0.86),
        ]
    }
}
