import Foundation

struct OverpassClient: Sendable {
    struct OverpassResponse: Decodable {
        let elements: [Element]
    }

    struct Element: Decodable {
        let id: Int
        let lat: Double?
        let lon: Double?
        let tags: [String: String]?
    }

    func fetchPOIs(lat: Double, lon: Double, radiusMeters: Int = 5000) async throws -> OverpassResponse {
        let query = """
        [out:json][timeout:25];
        (
          node(around:\(radiusMeters),\(lat),\(lon))[tourism];
          node(around:\(radiusMeters),\(lat),\(lon))[amenity~"restaurant|cafe|bar|pub"];
          node(around:\(radiusMeters),\(lat),\(lon))[leisure~"park|garden"];
          node(around:\(radiusMeters),\(lat),\(lon))[historic];
        );
        out body;
        """

        var request = URLRequest(url: URL(string: "https://overpass-api.de/api/interpreter")!)
        request.httpMethod = "POST"

        let body = "data=" + (query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        request.httpBody = body.data(using: .utf8)

        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
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

        return try JSONDecoder().decode(OverpassResponse.self, from: data)
    }
}

struct HTTPError: Error, CustomStringConvertible {
    let statusCode: Int
    let body: String

    var description: String { "HTTP \(statusCode): \(body)" }
}
