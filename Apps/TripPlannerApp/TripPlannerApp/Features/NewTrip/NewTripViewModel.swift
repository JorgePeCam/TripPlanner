import Foundation
import Observation
import TripPlannerKit

@MainActor
@Observable
final class NewTripViewModel {
    // Inputs
    var destination: String = ""
    var days: Int = 3
    var selectedPreferences: Set<Preference> = []

    // Output state
    private(set) var state: State = .idle

    private let generateItinerary: GenerateItineraryUseCase

    enum State: Equatable {
        case idle
        case loading
        case success(Itinerary)
        case failure(String)
    }

    init(generateItinerary: GenerateItineraryUseCase) {
        self.generateItinerary = generateItinerary
    }

    var canGenerate: Bool {
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && days > 0
    }

    func toggle(_ preference: Preference) {
        if selectedPreferences.contains(preference) {
            selectedPreferences.remove(preference)
        } else {
            selectedPreferences.insert(preference)
        }
    }

    func generateTapped() async {
        guard canGenerate else {
            state = .failure("Please enter a destination and select a valid number of days.")
            return
        }

        state = .loading
        do {
            let request = TripRequest(destination: destination, days: days, preferences: selectedPreferences)
            let itinerary = try await generateItinerary(request: request)
            state = .success(itinerary)
        } catch {
            state = .failure("Failed to generate itinerary. \(error.localizedDescription)")
        }
    }

    func resetResult() {
        state = .idle
    }
}
