public protocol PlacesRepository: Sendable {
    func topPlaces(for destination: String) async throws -> [POI]
}
