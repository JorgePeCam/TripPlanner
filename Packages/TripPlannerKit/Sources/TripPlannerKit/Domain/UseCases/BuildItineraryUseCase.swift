import Foundation

public struct BuildItineraryUseCase: Sendable {
    private let placesRepository: PlacesRepository

    public init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }

    public func callAsFunction(request: TripRequest) async throws -> Itinerary {
        let places = try await placesRepository.topPlaces(for: request.destination)

        let ranked = rank(places: places, with: request.preferences)
        let days = buildDays(destination: request.destination, daysCount: max(request.days, 1), rankedPlaces: ranked)

        return Itinerary(destination: request.destination, days: days)
    }

    private func rank(places: [POI], with preferences: Set<Preference>) -> [POI] {
        guard !preferences.isEmpty else {
            return places.sorted { $0.score > $1.score }
        }

        func boost(for poi: POI) -> Double {
            // Mapeo simple preferencias -> categorías
            var b: Double = 0
            if preferences.contains(.culture), (poi.category == .museum || poi.category == .landmark) { b += 0.15 }
            if preferences.contains(.food), poi.category == .food { b += 0.15 }
            if preferences.contains(.nature), poi.category == .park { b += 0.15 }
            if preferences.contains(.nightlife), poi.category == .neighborhood { b += 0.08 }
            if preferences.contains(.family), (poi.category == .park || poi.category == .neighborhood) { b += 0.1 }
            if preferences.contains(.lowBudget), poi.category == .park { b += 0.05 }
            return b
        }

        return places
            .map { poi in
                POI(id: poi.id, name: poi.name, category: poi.category, coordinate: poi.coordinate, score: poi.score + boost(for: poi))
            }
            .sorted { $0.score > $1.score }
    }

    private func buildDays(destination: String, daysCount: Int, rankedPlaces: [POI]) -> [ItineraryDay] {
        // 3 items por día (mañana/tarde/noche)
        let itemsPerDay = 3
        let needed = daysCount * itemsPerDay
        let selected = Array(rankedPlaces.prefix(needed))

        return (1...daysCount).map { dayIndex in
            let start = (dayIndex - 1) * itemsPerDay
            let slice = selected.dropFirst(start).prefix(itemsPerDay)

            let blocks: [TimeBlock] = [.morning, .afternoon, .evening]
            let items = zip(blocks, slice).map { block, poi in
                ItineraryItem(
                    timeBlock: block,
                    title: poi.name,
                    note: "\(poi.category.rawValue.capitalized) • score \(String(format: "%.2f", poi.score))"
                )
            }

            return ItineraryDay(id: dayIndex, title: "Day \(dayIndex)", items: items)
        }
    }
}
