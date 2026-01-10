# Data Sources (POIs)

## Providers
We currently use OpenStreetMap-based public services:

1) Nominatim (Geocoding)
- Input: "Rome"
- Output: latitude/longitude
- Requires a meaningful User-Agent header
- Subject to rate limiting

2) Overpass API (POIs)
- Input: lat/lon + radius
- Output: OSM elements (tags + coordinates)
- Can be slow or rate-limited; may require retries/fallback endpoints

## Notes
This setup is ideal for prototyping and portfolio projects. For production-scale usage, a commercial provider or hosted OSM stack is recommended.
