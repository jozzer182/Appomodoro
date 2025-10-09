import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: PomodoroSettings
    @State private var accentColor: Color

    let onSave: (PomodoroSettings) -> Void

    init(settings: PomodoroSettings, onSave: @escaping (PomodoroSettings) -> Void) {
        _draft = State(initialValue: settings)
        _accentColor = State(initialValue: settings.accentColor())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Presets") {
                    presetsRow
                }

                Section("Durations") {
                    durationStepper(title: "Focus", value: $draft.focusMinutes)
                    durationStepper(title: "Short Break", value: $draft.shortBreakMinutes)
                    durationStepper(title: "Long Break", value: $draft.longBreakMinutes)
                }

                Section("Behavior") {
                    Stepper(value: $draft.cyclesBeforeLongBreak, in: 1...8) {
                        HStack {
                            Text("Cycles before long break")
                            Spacer()
                            Text("\(draft.cyclesBeforeLongBreak)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Toggle("Auto-advance phases", isOn: $draft.autoAdvance)
                }

                Section("Appearance") {
                    ColorPicker("Accent color", selection: $accentColor, supportsOpacity: false)
                        .onChange(of: accentColor) { _, newValue in
                            draft = draft.updatingAccentColor(newValue)
                        }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                }
            }
        }
    }

    private var presetsRow: some View {
        HStack(spacing: 12) {
            presetButton(title: "25/5", focus: 25, short: 5, long: 15)
            presetButton(title: "50/10", focus: 50, short: 10, long: 20)
            presetButton(title: "Custom", focus: draft.focusMinutes, short: draft.shortBreakMinutes, long: draft.longBreakMinutes)
        }
    }

    private func presetButton(title: String, focus: Int, short: Int, long: Int) -> some View {
        Button {
            draft.focusMinutes = focus
            draft.shortBreakMinutes = short
            draft.longBreakMinutes = long
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }

    private func durationStepper(title: String, value: Binding<Int>) -> some View {
        Stepper(value: value, in: 1...180) {
            HStack {
                Text("\(title) minutes")
                Spacer()
                Text("\(value.wrappedValue)")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
