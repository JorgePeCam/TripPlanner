import Foundation

public struct Itinerary: Equatable {
    public let destination: String
    public let days: [ItineraryDay]
    
    public init(destination: String, days: [ItineraryDay]) {
        self.destination = destination
        self.days = days
    }
}

public struct ItineraryDay: Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let items: [ItineraryItem]
    
    public init(id: Int, title: String, items: [ItineraryItem]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

public struct ItineraryItem: Equatable, Identifiable {
    public let id: UUID
    public let timeBlock: TimeBlock
    public let title: String
    public let note: String?
    
    public init(id: UUID = UUID(), timeBlock: TimeBlock, title: String, note: String? = nil) {
        self.id = id
        self.timeBlock = timeBlock
        self.title = title
        self.note = note
    }
}

public enum TimeBlock: String, CaseIterable, Equatable {
    case morning, afternoon, evening
}
