import SwiftUI
import TripPlannerKit

@main
struct TripPlannerAppApp: App {
    var body: some Scene {
        WindowGroup {
            NewTripView(vm: .init(buildItinerary: makeBuildItineraryUseCase()))
        }
    }

    private func makeBuildItineraryUseCase() -> BuildItineraryUseCase {
        let placesRepository = MockPlacesRepository()
        return BuildItineraryUseCase(placesRepository: placesRepository)
    }
}
