import Foundation

/// Production implementation of `PlacesRepository` backed by OpenStreetMap services.
///
/// Responsibilities:
/// - Convert a human destination (e.g. "Rome") into coordinates using Nominatim (geocoding).
/// - Fetch nearby POIs using Overpass API.
/// - Map raw OSM tags into our domain model (`POI`, `PlaceCategory`) and compute a heuristic score.
///
/// Notes:
/// - Public API exposes a minimal surface (`init()` and `topPlaces`) to keep networking details internal.
/// - OSM services can rate-limit or fail intermittently; resilience (cache/retry/fallback) is added in Data layer.
/// - This repository is intentionally UI-agnostic and can be swapped for other providers (Google Places, Mapbox, etc.).
public struct OSMPlacesRepository: PlacesRepository {
    private let geocoder: NominatimClient
    private let overpass: OverpassClient

    public init() {
        self.geocoder = NominatimClient()
        self.overpass = OverpassClient()
    }

    // Internal init for advanced DI/testing within the package.
    init(geocoder: NominatimClient, overpass: OverpassClient) {
        self.geocoder = geocoder
        self.overpass = overpass
    }

    public func topPlaces(for destination: String) async throws -> [POI] {
        // Defensive trimming to avoid cache misses and low-quality queries.
        let destinationKey = destination.trimmingCharacters(in: .whitespacesAndNewlines)

        // 1) Geocode destination (string -> coordinates)
        let (lat, lon) = try await geocoder.geocode(destinationKey)

        // 2) Fetch POIs around the destination (Overpass can be slow / rate-limited)
        let response = try await overpass.fetchPOIs(lat: lat, lon: lon, radiusMeters: 8000)

        // 3) Map raw OSM elements to domain POIs (ignore elements without name/coordinates)
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

        // 4) Return top-N results to keep the UI responsive and the itinerary builder deterministic.
        return Array(pois.sorted { $0.score > $1.score }.prefix(30))
    }

    /// Maps OSM tags to our `PlaceCategory`. This is a heuristic and can evolve over time.
    private func mapCategory(tags: [String: String]) -> PlaceCategory {
        if tags["tourism"] == "museum" { return .museum }
        if tags["tourism"] == "attraction" { return .landmark }
        if tags["tourism"] == "viewpoint" { return .viewpoint }
        if tags["historic"] != nil { return .landmark }
        if tags["leisure"] == "park" || tags["leisure"] == "garden" { return .park }
        if let amenity = tags["amenity"], ["restaurant", "cafe", "bar", "pub"].contains(amenity) { return .food }
        return .neighborhood
    }

    /// Computes a base score to rank POIs. Later we can incorporate:
    /// - distance from center
    /// - popularity / wikidata / ratings (if provider supports)
    /// - user preferences (currently done in `BuildItineraryUseCase`)
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
