import Foundation

public struct POI: Equatable, Identifiable {
    public let id: String
    public let name: String
    public let category: PlaceCategory
    public let coordinate: Coordinate
    public let score: Double

    public init(id: String, name: String, category: PlaceCategory, coordinate: Coordinate, score: Double) {
        self.id = id
        self.name = name
        self.category = category
        self.coordinate = coordinate
        self.score = score
    }
}

public struct Coordinate: Equatable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public enum PlaceCategory: String, CaseIterable, Equatable {
    case landmark
    case museum
    case park
    case food
    case neighborhood
    case viewpoint
}
