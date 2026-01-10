import Foundation

struct NominatimClient: Sendable {
    struct Place: Decodable {
        let lat: String
        let lon: String
        let display_name: String
    }

    func geocode(_ query: String) async throws -> (lat: Double, lon: Double) {
        var components = URLComponents(string: "https://nominatim.openstreetmap.org/search")!
        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "format", value: "json"),
            .init(name: "limit", value: "1")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("TripPlanner/1.0 (iOS 17; contact: jorge)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            throw HTTPError(statusCode: http.statusCode, body: body)
        }

        let results = try JSONDecoder().decode([Place].self, from: data)
        guard let first = results.first,
              let lat = Double(first.lat),
              let lon = Double(first.lon) else {
            throw GeocodingError.noResults
        }

        return (lat, lon)
    }

    enum GeocodingError: Error {
        case noResults
    }
}
