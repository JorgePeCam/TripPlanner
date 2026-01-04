import SwiftUI
import TripPlannerKit

@main
struct TripPlannerAppApp: App {
    var body: some Scene {
        WindowGroup {
            NewTripView(vm: .init(generateItinerary: makeGenerateItineraryUseCase()))
        }
    }

    private func makeGenerateItineraryUseCase() -> GenerateItineraryUseCase {
        // Por ahora fake. Luego aquí cambiaremos a AIItineraryGenerator.
        let generator = FakeItineraryGenerator()
        return GenerateItineraryUseCase(generator: generator)
    }
}
