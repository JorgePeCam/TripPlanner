import Foundation
import TripPlannerKit

public struct FakeItineraryGenerator: ItineraryGenerator {
    public init() {}
    
    public func generate(request: TripRequest) async throws -> Itinerary {
        let days = (1...max(request.days, 1)).map { day in
            ItineraryDay(
                id: day,
                title: "Day \(day)",
                items: [
                    ItineraryItem(timeBlock: .morning, title: "Walk in the city center", note: "Start easy"),
                    ItineraryItem(timeBlock: .afternoon, title: "Visit a top attraction", note: "Based on your preferences"),
                    ItineraryItem(timeBlock: .evening, title: "Dinner in a local neighborhood", note: nil)
                ]
            )
        }
        return Itinerary(destination: request.destination, days: days)
    }
}
