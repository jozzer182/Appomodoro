import Foundation

struct PomodoroTimerState: Codable, Equatable {
    private(set) var currentPhase: PomodoroPhase = .focus
    private(set) var startedAtReference: TimeInterval?
    private(set) var accumulatedPause: TimeInterval = 0
    private(set) var lastPausedElapsed: TimeInterval = 0
    private(set) var pauseReference: TimeInterval?
    private(set) var isRunning: Bool = false
    private(set) var totalFocusSessionsCompleted: Int = 0

    mutating func start(at referenceDate: TimeInterval) {
        startedAtReference = referenceDate
        accumulatedPause = 0
        lastPausedElapsed = 0
        pauseReference = nil
        isRunning = true
    }

    mutating func pause(at referenceDate: TimeInterval) {
        guard isRunning, let started = startedAtReference else { return }
        let elapsed = referenceDate - started - accumulatedPause
        lastPausedElapsed = max(0, elapsed)
        pauseReference = referenceDate
        isRunning = false
    }

    mutating func resume(at referenceDate: TimeInterval) {
        guard !isRunning, let pauseReference else { return }
        accumulatedPause += referenceDate - pauseReference
        self.pauseReference = nil
        isRunning = true
    }

    mutating func stop() {
        isRunning = false
        startedAtReference = nil
        accumulatedPause = 0
        lastPausedElapsed = 0
        pauseReference = nil
    }

    mutating func transitionToNextPhase(autoStart: Bool, using settings: PomodoroSettings, at referenceDate: TimeInterval) {
        if currentPhase == .focus {
            totalFocusSessionsCompleted += 1
        }
        currentPhase = nextPhase(using: settings)
        accumulatedPause = 0
        lastPausedElapsed = 0
        pauseReference = nil

        if autoStart {
            startedAtReference = referenceDate
            isRunning = true
        } else {
            startedAtReference = nil
            isRunning = false
        }
    }

    mutating func reset(to phase: PomodoroPhase = .focus) {
        currentPhase = phase
        startedAtReference = nil
        accumulatedPause = 0
        lastPausedElapsed = 0
        pauseReference = nil
        isRunning = false
        totalFocusSessionsCompleted = 0
    }

    mutating func jump(to phase: PomodoroPhase, autoStart: Bool, at referenceDate: TimeInterval) {
        currentPhase = phase
        accumulatedPause = 0
        lastPausedElapsed = 0
        pauseReference = nil
        if autoStart {
            startedAtReference = referenceDate
            isRunning = true
        } else {
            startedAtReference = nil
            isRunning = false
        }
    }

    func elapsed(at referenceDate: TimeInterval) -> TimeInterval {
        guard let started = startedAtReference else { return lastPausedElapsed }
        if isRunning {
            return max(0, referenceDate - started - accumulatedPause)
        }
        return lastPausedElapsed
    }

    func remainingDuration(using settings: PomodoroSettings, at referenceDate: TimeInterval) -> TimeInterval {
        max(0, settings.duration(for: currentPhase) - elapsed(at: referenceDate))
    }

    func progress(using settings: PomodoroSettings, at referenceDate: TimeInterval) -> Double {
        let total = settings.duration(for: currentPhase)
        guard total > 0 else { return 0 }
        return min(1, elapsed(at: referenceDate) / total)
    }

    func nextPhase(using settings: PomodoroSettings) -> PomodoroPhase {
        switch currentPhase {
        case .focus:
            guard settings.cyclesBeforeLongBreak > 0 else { return .shortBreak }
            return totalFocusSessionsCompleted % settings.cyclesBeforeLongBreak == 0 ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            return .focus
        }
    }
}
