import Foundation
import Observation
import TripPlannerKit

@MainActor
@Observable
final class NewTripViewModel {
    // MARK: - Inputs
    var destination: String = ""
    var days: Int = 3
    var selectedPreferences: Set<Preference> = []

    // MARK: - Output state
    private(set) var state: State = .idle

    private let buildItinerary: BuildItineraryUseCase

    enum State: Equatable {
        case idle
        case loading
        case success(Itinerary)
        case failure(String)
    }

    init(buildItinerary: BuildItineraryUseCase) {
        self.buildItinerary = buildItinerary
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
            let request = TripRequest(
                destination: destination.trimmingCharacters(in: .whitespacesAndNewlines),
                days: days,
                preferences: selectedPreferences
            )

            let itinerary = try await buildItinerary(request: request)
            state = .success(itinerary)
        } catch {
            print("Generate error:", error)
            state = .failure("Failed to generate itinerary. \(error.localizedDescription)")
        }
    }

    func resetResult() {
        state = .idle
    }
}

extension NewTripViewModel {
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
}
