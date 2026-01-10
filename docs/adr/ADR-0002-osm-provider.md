# ADR-0002: Use OSM (Nominatim + Overpass) for POIs (initial version)

## Status
Accepted

## Context
We need a POI provider to build itineraries from a destination input.

## Decision
Use Nominatim for geocoding and Overpass for POI discovery.

## Consequences
Pros:
- No API key
- Good enough for prototyping and portfolio

Cons:
- Rate limiting / reliability constraints
- Requires caching, retries, and potentially fallback endpoints
