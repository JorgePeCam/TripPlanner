import XCTest
@testable import TripPlannerKit

final class BuildItineraryUseCaseTests: XCTestCase {

    func test_generatesCorrectNumberOfDays() async throws {
        let repo = MockPlacesRepository()
        let sut = BuildItineraryUseCase(placesRepository: repo)

        let request = TripRequest(
            destination: "Rome",
            days: 3,
            preferences: []
        )

        let itinerary = try await sut(request: request)

        XCTAssertEqual(itinerary.days.count, 3)
    }

    func test_eachDayHasThreeItems() async throws {
        let repo = MockPlacesRepository()
        let sut = BuildItineraryUseCase(placesRepository: repo)

        let request = TripRequest(
            destination: "Paris",
            days: 2,
            preferences: []
        )

        let itinerary = try await sut(request: request)

        XCTAssertTrue(itinerary.days.allSatisfy { $0.items.count == 3 })
    }

    func test_preferencesBoostRelevantCategories() async throws {
        let repo = MockPlacesRepository()
        let sut = BuildItineraryUseCase(placesRepository: repo)

        let request = TripRequest(
            destination: "Barcelona",
            days: 1,
            preferences: [.food]
        )

        let itinerary = try await sut(request: request)
        let firstItem = itinerary.days.first?.items.first

        XCTAssertNotNil(firstItem)
        XCTAssertTrue(firstItem?.title.lowercased().contains("food") ?? false)
    }

    func test_zeroDaysDefaultsToOneDay() async throws {
        let repo = MockPlacesRepository()
        let sut = BuildItineraryUseCase(placesRepository: repo)

        let request = TripRequest(
            destination: "Berlin",
            days: 0,
            preferences: []
        )

        let itinerary = try await sut(request: request)

        XCTAssertEqual(itinerary.days.count, 1)
    }
}
