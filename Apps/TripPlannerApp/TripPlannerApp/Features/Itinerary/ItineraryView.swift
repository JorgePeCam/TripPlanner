import SwiftUI
import TripPlannerKit

struct ItineraryView: View {
    let itinerary: Itinerary

    var body: some View {
        List {
            ForEach(itinerary.days) { day in
                Section(day.title) {
                    ForEach(day.items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.timeBlock.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            Text(item.title)
                                .font(.body)

                            if let note = item.note, !note.isEmpty {
                                Text(note)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(itinerary.destination)
        .navigationBarTitleDisplayMode(.inline)
    }
}
