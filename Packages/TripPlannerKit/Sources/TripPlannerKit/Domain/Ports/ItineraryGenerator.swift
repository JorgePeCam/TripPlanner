public protocol ItineraryGenerator {
    func generate(request: TripRequest) async throws -> Itinerary
}
