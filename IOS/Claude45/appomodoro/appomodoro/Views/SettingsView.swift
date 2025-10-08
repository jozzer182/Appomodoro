//
//  SettingsView.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI

/// Settings view for configuring Pomodoro parameters and theme
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: PomodoroViewModel
    @State private var showingColorPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Presets section
                Section("Presets") {
                    Button("25/5 Classic") {
                        viewModel.applyPreset(.preset25_5)
                        Haptics.playSelection()
                    }
                    
                    Button("50/10 Extended") {
                        viewModel.applyPreset(.preset50_10)
                        Haptics.playSelection()
                    }
                }
                
                // Custom durations section
                Section("Custom Durations") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Focus: \(Int(viewModel.settings.focusDuration / 60)) min")
                        Slider(
                            value: Binding(
                                get: { viewModel.settings.focusDuration / 60 },
                                set: { viewModel.settings.focusDuration = $0 * 60 }
                            ),
                            in: 1...90,
                            step: 1
                        )
                        .tint(viewModel.settings.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Short Break: \(Int(viewModel.settings.shortBreakDuration / 60)) min")
                        Slider(
                            value: Binding(
                                get: { viewModel.settings.shortBreakDuration / 60 },
                                set: { viewModel.settings.shortBreakDuration = $0 * 60 }
                            ),
                            in: 1...30,
                            step: 1
                        )
                        .tint(viewModel.settings.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Long Break: \(Int(viewModel.settings.longBreakDuration / 60)) min")
                        Slider(
                            value: Binding(
                                get: { viewModel.settings.longBreakDuration / 60 },
                                set: { viewModel.settings.longBreakDuration = $0 * 60 }
                            ),
                            in: 5...60,
                            step: 1
                        )
                        .tint(viewModel.settings.accentColor)
                    }
                }
                
                // Behavior section
                Section("Behavior") {
                    Stepper(
                        "Focus cycles to long break: \(viewModel.settings.cyclesToLongBreak)",
                        value: $viewModel.settings.cyclesToLongBreak,
                        in: 2...10
                    )
                    
                    Toggle("Auto-advance to next phase", isOn: $viewModel.settings.autoAdvance)
                        .tint(viewModel.settings.accentColor)
                }
                
                // Theme section
                Section("Theme") {
                    HStack {
                        Text("Accent Color")
                        Spacer()
                        Circle()
                            .fill(viewModel.settings.accentColor)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                showingColorPicker = true
                            }
                    }
                }
                
                // Statistics section
                Section("Statistics") {
                    HStack {
                        Text("Completed Focus Sessions")
                        Spacer()
                        Text("\(viewModel.timerState.completedFocusCycles)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingColorPicker) {
                ColorPickerView(selectedColor: Binding(
                    get: { viewModel.settings.accentColor },
                    set: { viewModel.updateAccentColor($0) }
                ))
            }
        }
    }
}

/// Custom color picker view
struct ColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColor: Color
    @State private var tempColor: Color
    
    init(selectedColor: Binding<Color>) {
        self._selectedColor = selectedColor
        self._tempColor = State(initialValue: selectedColor.wrappedValue)
    }
    
    let presetColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal,
        .cyan, .blue, .indigo, .purple, .pink, .brown
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Color preview
                RoundedRectangle(cornerRadius: 16)
                    .fill(tempColor)
                    .frame(height: 120)
                    .padding()
                
                // Preset colors grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 6), spacing: 16) {
                    ForEach(presetColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: tempColor == color ? 3 : 0)
                            )
                            .onTapGesture {
                                tempColor = color
                                Haptics.playSelection()
                            }
                    }
                }
                .padding()
                
                // Native color picker
                ColorPicker("Custom Color", selection: $tempColor, supportsOpacity: false)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Choose Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        selectedColor = tempColor
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: PomodoroViewModel())
}
