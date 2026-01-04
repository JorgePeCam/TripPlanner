public struct TripRequest: Equatable {
    public let destination: String
    public let days: Int
    public let preferences: Set<Preference>
    
    public init(destination: String, days: Int, preferences: Set<Preference>) {
        self.destination = destination
        self.days = days
        self.preferences = preferences
    }
}

public enum Preference: String, CaseIterable, Hashable {
    case culture
    case food
    case nature
    case nightlife
    case family
    case lowBudget
}
