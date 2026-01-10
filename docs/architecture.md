# TripPlanner Architecture

## Overview
TripPlanner follows a modular approach:
- `TripPlannerApp` (iOS app): SwiftUI UI + composition root (DI)
- `TripPlannerKit` (Swift Package): domain logic, data implementations, and feature modules

## Modules
**TripPlannerKit**
- Domain: models, ports (protocols), use cases
- Data: implementations of ports (network providers, repositories)
- Features: orchestration for UI-facing logic (optional, grows later)
- Core: shared utilities (logging, formatting, etc.)

## Dependency rule
- Domain depends on nothing
- Data depends on Domain
- App depends on TripPlannerKit

## Current flow (MVP)
NewTripView -> NewTripViewModel -> BuildItineraryUseCase -> PlacesRepository (OSMPlacesRepository)
