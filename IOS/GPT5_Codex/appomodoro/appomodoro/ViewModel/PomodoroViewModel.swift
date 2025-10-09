import SwiftUI
import Combine

@MainActor
final class PomodoroViewModel: ObservableObject {
    @Published private(set) var settings: PomodoroSettings
    @Published private(set) var timerState: PomodoroTimerState
    @Published var isShowingSettings: Bool = false

    private let notificationService: NotificationService
    private let haptics: Haptics
    private let defaults: UserDefaults
    private var cancellables = Set<AnyCancellable>()

    private enum DefaultsKey {
        static let settings = "ios.appomodoro.settings"
        static let timerState = "ios.appomodoro.timerState"
    }

    init(notificationService: NotificationService? = nil,
         haptics: Haptics? = nil,
         defaults: UserDefaults = .standard) {
        self.notificationService = notificationService ?? NotificationService.shared
        self.haptics = haptics ?? Haptics.shared
        self.defaults = defaults

        let decoder = JSONDecoder()
        if let data = defaults.data(forKey: DefaultsKey.settings),
           let decoded = try? decoder.decode(PomodoroSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }

        if let data = defaults.data(forKey: DefaultsKey.timerState),
           let decoded = try? decoder.decode(PomodoroTimerState.self, from: data) {
            timerState = decoded
        } else {
            timerState = PomodoroTimerState()
        }

    Task { await self.notificationService.requestAuthorizationIfNeeded() }
    }

    // MARK: - Intent

    func start() {
        let now = Date().timeIntervalSinceReferenceDate
        var state = timerState
        state.start(at: now)
        timerState = state
        persistTimerState()
        scheduleNotification(referenceDate: now)
    }

    func pause() {
        guard timerState.isRunning else { return }
        let now = Date().timeIntervalSinceReferenceDate
        var state = timerState
        state.pause(at: now)
        timerState = state
        persistTimerState()
        notificationService.cancelAllScheduled()
    }

    func resume() {
        guard !timerState.isRunning else { return }
        let now = Date().timeIntervalSinceReferenceDate
        var state = timerState
        state.resume(at: now)
        timerState = state
        persistTimerState()
        scheduleNotification(referenceDate: now)
    }

    func reset() {
        var state = timerState
        state.reset(to: .focus)
        timerState = state
        persistTimerState()
        notificationService.cancelAllScheduled()
    }

    func skipToNextPhase() {
        let now = Date().timeIntervalSinceReferenceDate
        var state = timerState
        state.transitionToNextPhase(autoStart: settings.autoAdvance, using: settings, at: now)
        timerState = state
        persistTimerState()
        notificationService.cancelAllScheduled()
        if state.isRunning {
            scheduleNotification(referenceDate: now)
        }
    }

    func update(settings newSettings: PomodoroSettings) {
        settings = newSettings
        persistSettings()
        let now = Date().timeIntervalSinceReferenceDate
        if timerState.isRunning {
            notificationService.cancelAllScheduled()
            scheduleNotification(referenceDate: now)
        }
    }

    func setAccentColor(_ color: Color) {
        update(settings: settings.updatingAccentColor(color))
    }

    func applyPreset(focus: Int, shortBreak: Int, longBreak: Int) {
        var updated = settings
        updated.focusMinutes = focus
        updated.shortBreakMinutes = shortBreak
        updated.longBreakMinutes = longBreak
        update(settings: updated)
    }

    func updateAutoAdvance(_ enabled: Bool) {
        var updated = settings
        updated.autoAdvance = enabled
        update(settings: updated)
    }

    func updateCyclesBeforeLongBreak(_ count: Int) {
        var updated = settings
        updated.cyclesBeforeLongBreak = max(1, count)
        update(settings: updated)
    }

    func handleTick(at referenceDate: TimeInterval) {
        guard timerState.isRunning else { return }
        let remaining = timerState.remainingDuration(using: settings, at: referenceDate)
        if remaining <= 0 {
            phaseDidComplete(at: referenceDate)
        }
    }

    func remainingComponents(at referenceDate: TimeInterval) -> (minutes: Int, seconds: Int) {
        let clamped = max(0, timerState.remainingDuration(using: settings, at: referenceDate))
        let minutes = Int(clamped) / 60
        let seconds = Int(clamped) % 60
        return (minutes, seconds)
    }

    func phaseProgress(at referenceDate: TimeInterval) -> Double {
        timerState.progress(using: settings, at: referenceDate)
    }

    func referenceDate() -> TimeInterval {
        Date().timeIntervalSinceReferenceDate
    }

    // MARK: - Private helpers

    private func phaseDidComplete(at referenceDate: TimeInterval) {
        notificationService.cancelAllScheduled()
        haptics.notify(.success)

        var state = timerState
        state.transitionToNextPhase(autoStart: settings.autoAdvance, using: settings, at: referenceDate)
        timerState = state
        persistTimerState()

        if state.isRunning {
            scheduleNotification(referenceDate: referenceDate)
        }
    }

    private func scheduleNotification(referenceDate: TimeInterval) {
        guard timerState.isRunning else { return }
        let remaining = timerState.remainingDuration(using: settings, at: referenceDate)
        guard remaining > 0 else { return }
        notificationService.schedulePhaseEndNotification(
            phase: timerState.currentPhase,
            fireIn: remaining,
            settings: settings
        )
    }

    private func persistTimerState() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(timerState) {
            defaults.set(data, forKey: DefaultsKey.timerState)
        }
    }

    private func persistSettings() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(settings) {
            defaults.set(data, forKey: DefaultsKey.settings)
        }
    }
}
