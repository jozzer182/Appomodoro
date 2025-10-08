//
//  ContentView.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var viewModel = PomodoroViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(white: 0.08), Color(white: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Main dial view
                DialView(
                    timerState: viewModel.timerState,
                    remaining: viewModel.remaining,
                    accentColor: viewModel.settings.accentColor
                )
                .frame(maxWidth: 400, maxHeight: 400)
                .aspectRatio(1, contentMode: .fit)
                .padding()
                
                Spacer()
                
                // Control bar
                ControlBar(viewModel: viewModel)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                // App became active - check if phase completed while in background
                viewModel.checkPhaseCompletion()
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            // Periodic check for phase completion
            if viewModel.isRunning {
                viewModel.checkPhaseCompletion()
            }
        }
        // Accessibility
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Pomodoro Timer")
        .accessibilityValue("Time remaining: \(Int(viewModel.remaining / 60)) minutes \(Int(viewModel.remaining.truncatingRemainder(dividingBy: 60))) seconds")
    }
}

#Preview {
    ContentView()
}
