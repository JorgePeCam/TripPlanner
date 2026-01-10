import Foundation

public struct OSMPlacesRepository: PlacesRepository {
    private let geocoder: NominatimClient
    private let overpass: OverpassClient

    public init() {
        self.geocoder = NominatimClient()
        self.overpass = OverpassClient()
    }

    // Init interno para tests / DI avanzado dentro del package (no visible fuera)
    init(geocoder: NominatimClient, overpass: OverpassClient) {
        self.geocoder = geocoder
        self.overpass = overpass
    }

    public func topPlaces(for destination: String) async throws -> [POI] {
        let (lat, lon) = try await geocoder.geocode(destination)
        let response = try await overpass.fetchPOIs(lat: lat, lon: lon, radiusMeters: 8000)

        let pois: [POI] = response.elements.compactMap { element in
            guard let tags = element.tags else { return nil }
            guard let name = tags["name"], !name.isEmpty else { return nil }
            guard let lat = element.lat, let lon = element.lon else { return nil }

            let category = mapCategory(tags: tags)
            let score = baseScore(tags: tags, category: category)

            return POI(
                id: "\(element.id)",
                name: name,
                category: category,
                coordinate: .init(latitude: lat, longitude: lon),
                score: score
            )
        }

        return Array(pois.sorted { $0.score > $1.score }.prefix(30))
    }

    private func mapCategory(tags: [String: String]) -> PlaceCategory {
        if tags["tourism"] == "museum" { return .museum }
        if tags["tourism"] == "attraction" { return .landmark }
        if tags["tourism"] == "viewpoint" { return .viewpoint }
        if tags["historic"] != nil { return .landmark }
        if tags["leisure"] == "park" || tags["leisure"] == "garden" { return .park }
        if let amenity = tags["amenity"], ["restaurant", "cafe", "bar", "pub"].contains(amenity) { return .food }
        return .neighborhood
    }

    private func baseScore(tags: [String: String], category: PlaceCategory) -> Double {
        var score: Double = 0.5

        if tags["tourism"] != nil { score += 0.2 }
        if tags["historic"] != nil { score += 0.2 }

        switch category {
        case .landmark: score += 0.2
        case .museum: score += 0.15
        case .park: score += 0.1
        case .food: score += 0.08
        case .viewpoint: score += 0.12
        case .neighborhood: score += 0.05
        }

        return min(score, 1.0)
    }
}
