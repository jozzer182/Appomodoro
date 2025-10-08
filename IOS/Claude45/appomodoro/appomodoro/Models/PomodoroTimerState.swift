//
//  PomodoroTimerState.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import Foundation

/// Represents the current state of the Pomodoro timer
struct PomodoroTimerState: Codable {
    var currentPhase: PomodoroPhase
    var isRunning: Bool
    var startedAt: TimeInterval?              // Date.timeIntervalSinceReferenceDate when timer started
    var accumulatedPause: TimeInterval        // total pause time accumulated
    var lastPausedElapsed: TimeInterval       // elapsed time when last paused
    var completedFocusCycles: Int             // count of completed focus sessions
    
    static let initial = PomodoroTimerState(
        currentPhase: .focus,
        isRunning: false,
        startedAt: nil,
        accumulatedPause: 0,
        lastPausedElapsed: 0,
        completedFocusCycles: 0
    )
    
    /// Calculate elapsed time based on current timestamp
    func elapsed(at timestamp: TimeInterval) -> TimeInterval {
        if isRunning, let start = startedAt {
            return timestamp - start - accumulatedPause
        } else {
            return lastPausedElapsed
        }
    }
    
    /// Calculate remaining time for current phase
    func remaining(at timestamp: TimeInterval, phaseDuration: TimeInterval) -> TimeInterval {
        let elapsed = self.elapsed(at: timestamp)
        return max(0, phaseDuration - elapsed)
    }
    
    /// Check if current phase is complete
    func isPhaseComplete(at timestamp: TimeInterval, phaseDuration: TimeInterval) -> Bool {
        return remaining(at: timestamp, phaseDuration: phaseDuration) <= 0
    }
}
