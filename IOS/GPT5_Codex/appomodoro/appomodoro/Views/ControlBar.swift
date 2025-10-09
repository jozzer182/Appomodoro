import SwiftUI

struct ControlBar: View {
    @ObservedObject var viewModel: PomodoroViewModel
    let referenceDate: TimeInterval

    private var isRunning: Bool { viewModel.timerState.isRunning }
    private var remaining: TimeInterval {
        viewModel.timerState.remainingDuration(using: viewModel.settings, at: referenceDate)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(action: primaryAction) {
                    Label(isRunning ? "Pause" : (remaining <= 0 ? "Start" : "Resume"), systemImage: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PillButtonStyle(color: viewModel.settings.accentColor()))

                Button {
                    viewModel.skipToNextPhase()
                } label: {
                    Label("Next", systemImage: "forward.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PillButtonStyle(color: Color.white.opacity(0.12), foreground: .white))
            }

            HStack(spacing: 16) {
                Button {
                    viewModel.reset()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PillButtonStyle(color: Color.white.opacity(0.08), foreground: .white))

                Button {
                    viewModel.isShowingSettings = true
                } label: {
                    Label("Settings", systemImage: "slider.horizontal.3")
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PillButtonStyle(color: Color.white.opacity(0.08), foreground: .white))
            }
        }
        .padding(.horizontal, 24)
    }

    private func primaryAction() {
        if isRunning {
            viewModel.pause()
        } else if remaining <= 0 || viewModel.timerState.startedAtReference == nil {
            viewModel.start()
        } else {
            viewModel.resume()
        }
    }
}

struct PillButtonStyle: ButtonStyle {
    var color: Color
    var foreground: Color = .black

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(color.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundStyle(foreground)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}
