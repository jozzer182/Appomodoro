//
//  ControlBar.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI

/// Control bar with play/pause, reset, and next phase buttons
struct ControlBar: View {
    @Bindable var viewModel: PomodoroViewModel
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Phase indicator
            HStack(spacing: 12) {
                Image(systemName: viewModel.currentPhase.systemImageName)
                    .font(.title2)
                Text(viewModel.currentPhase.description)
                    .font(.title3.weight(.semibold))
            }
            .foregroundStyle(viewModel.settings.accentColor)
            .padding(.bottom, 8)
            
            // Main controls
            HStack(spacing: 24) {
                // Reset button
                Button(action: {
                    viewModel.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                .foregroundStyle(.white)
                .disabled(!viewModel.isRunning && viewModel.elapsed == 0)
                
                // Play/Pause button
                Button(action: {
                    if viewModel.isRunning {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .frame(width: 70, height: 70)
                        .background(Circle().fill(viewModel.settings.accentColor))
                }
                .foregroundStyle(.white)
                
                // Next phase button
                Button(action: {
                    viewModel.nextPhase()
                }) {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                .foregroundStyle(.white)
            }
            .padding(.bottom, 12)
            
            // Settings button
            Button(action: {
                showingSettings = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: viewModel)
        }
    }
}

#Preview {
    ControlBar(viewModel: PomodoroViewModel())
        .background(Color.black)
}
