import SwiftUI
import TripPlannerKit

struct NewTripView: View {
    @State private var vm: NewTripViewModel

    init(vm: NewTripViewModel) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Destination") {
                    TextField("e.g. Rome, Tokyo, Lisbon", text: $vm.destination)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                }

                Section("Duration") {
                    Stepper(value: $vm.days, in: 1...30) {
                        HStack {
                            Text("Days")
                            Spacer()
                            Text("\(vm.days)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Preferences") {
                    PreferencesGrid(
                        all: Preference.allCases,
                        selected: vm.selectedPreferences,
                        onToggle: vm.toggle
                    )
                }

                Section {
                    Button {
                        Task { await vm.generateTapped() }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Generate itinerary")
                            Spacer()
                        }
                    }
                    .disabled(!vm.canGenerate || vm.isLoading)
                }

                if case .failure(let message) = vm.state {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if vm.isLoading {
                    ProgressView("Generating…")
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .navigationDestination(isPresented: bindingToSuccess) {
                if case .success(let itinerary) = vm.state {
                    ItineraryView(itinerary: itinerary)
                        .onDisappear { vm.resetResult() }
                }
            }
        }
    }

    private var bindingToSuccess: Binding<Bool> {
        Binding(
            get: {
                if case .success = vm.state { return true }
                return false
            },
            set: { newValue in
                if !newValue { vm.resetResult() }
            }
        )
    }
}

private extension NewTripViewModel {
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
}
