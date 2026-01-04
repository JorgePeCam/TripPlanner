import SwiftUI
import TripPlannerKit

struct PreferencesGrid: View {
    let all: [Preference]
    let selected: Set<Preference>
    let onToggle: (Preference) -> Void

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(all, id: \.self) { pref in
                let isSelected = selected.contains(pref)

                Button {
                    onToggle(pref)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: icon(for: pref))
                        Text(title(for: pref))
                            .font(.body)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(isSelected ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(title(for: pref))
                .accessibilityHint(isSelected ? "Selected" : "Not selected")
            }
        }
        .padding(.vertical, 4)
    }

    private func title(for pref: Preference) -> String {
        switch pref {
        case .culture: return "Culture"
        case .food: return "Food"
        case .nature: return "Nature"
        case .nightlife: return "Nightlife"
        case .family: return "Family"
        case .lowBudget: return "Low budget"
        }
    }

    private func icon(for pref: Preference) -> String {
        switch pref {
        case .culture: return "building.columns"
        case .food: return "fork.knife"
        case .nature: return "leaf"
        case .nightlife: return "sparkles"
        case .family: return "figure.2.and.child.holdinghands"
        case .lowBudget: return "eurosign.circle"
        }
    }
}
