//
//  ContentView.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PomodoroViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline -> AnyView in
            let referenceDate = timeline.date.timeIntervalSinceReferenceDate
            viewModel.handleTick(at: referenceDate)

            let accent = viewModel.settings.accentColor()
            let remaining = viewModel.remainingComponents(at: referenceDate)
            let voiceOver = "Time remaining \(remaining.minutes) minutes \(remaining.seconds) seconds"

            return AnyView(
                ZStack {
                    LinearGradient(
                        colors: [Color(red: 0.05, green: 0.05, blue: 0.08), Color(red: 0.02, green: 0.02, blue: 0.04)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 32) {
                        Spacer()
                        Text(viewModel.timerState.currentPhase.displayName.uppercased())
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.top, 12)
                        DialView(
                            timerState: viewModel.timerState,
                            settings: viewModel.settings,
                            referenceDate: referenceDate,
                            accentColor: accent
                        )
                        .frame(width: 320, height: 320)
                        .padding(.horizontal, 24)
                        .accessibilityLabel(Text(voiceOver))

                        ControlBar(viewModel: viewModel, referenceDate: referenceDate)
                        Spacer()
                    }
                    .padding(.vertical, 32)
                }
            )
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                let now = Date().timeIntervalSinceReferenceDate
                viewModel.handleTick(at: now)
            }
        }
        .sheet(isPresented: $viewModel.isShowingSettings) {
            SettingsView(settings: viewModel.settings) { updated in
                viewModel.update(settings: updated)
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
