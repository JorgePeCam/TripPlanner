public struct GenerateItineraryUseCase {
    private let generator: ItineraryGenerator
    
    public init(generator: ItineraryGenerator) {
        self.generator = generator
    }
    
    public func callAsFunction(request: TripRequest) async throws -> Itinerary {
        try await generator.generate(request: request)
    }
}
