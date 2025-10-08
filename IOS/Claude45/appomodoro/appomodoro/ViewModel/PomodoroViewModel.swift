//
//  PomodoroViewModel.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI
import Combine

/// Main view model for Pomodoro timer logic and state management
@MainActor
@Observable
class PomodoroViewModel {
    
    // MARK: - Published State
    private(set) var timerState: PomodoroTimerState
    var settings: PomodoroSettings {
        didSet {
            saveSettings()
        }
    }
    
    // MARK: - Private Properties
    private var timer: Timer?
    private let notificationService = NotificationService.shared
    
    // MARK: - Computed Properties
    var currentPhaseDuration: TimeInterval {
        switch timerState.currentPhase {
        case .focus:
            return settings.focusDuration
        case .shortBreak:
            return settings.shortBreakDuration
        case .longBreak:
            return settings.longBreakDuration
        }
    }
    
    var elapsed: TimeInterval {
        let now = Date().timeIntervalSinceReferenceDate
        return timerState.elapsed(at: now)
    }
    
    var remaining: TimeInterval {
        let now = Date().timeIntervalSinceReferenceDate
        return timerState.remaining(at: now, phaseDuration: currentPhaseDuration)
    }
    
    var isRunning: Bool {
        timerState.isRunning
    }
    
    var currentPhase: PomodoroPhase {
        timerState.currentPhase
    }
    
    // MARK: - Initialization
    init() {
        // Load settings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "pomodoroSettings"),
           let decoded = try? JSONDecoder().decode(PomodoroSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = .default
        }
        
        // Load timer state from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "pomodoroTimerState"),
           let decoded = try? JSONDecoder().decode(PomodoroTimerState.self, from: data) {
            self.timerState = decoded
            
            // If timer was running when app was closed, adjust for background time
            if decoded.isRunning {
                // Recompute elapsed time and check if phase is complete
                let now = Date().timeIntervalSinceReferenceDate
                if timerState.isPhaseComplete(at: now, phaseDuration: currentPhaseDuration) {
                    // Phase completed while app was in background
                    completePhase()
                }
            }
        } else {
            self.timerState = .initial
        }
        
        // Request notification permission
        Task {
            _ = await notificationService.requestAuthorization()
        }
    }
    
    // MARK: - Timer Control
    func start() {
        let now = Date().timeIntervalSinceReferenceDate
        
        if timerState.startedAt == nil {
            // First start
            timerState.startedAt = now
            timerState.accumulatedPause = 0
            timerState.lastPausedElapsed = 0
        } else {
            // Resume from pause
            timerState.accumulatedPause += now - (timerState.startedAt ?? now) - timerState.lastPausedElapsed
        }
        
        timerState.isRunning = true
        saveTimerState()
        schedulePhaseNotification()
        Haptics.playLight()
    }
    
    func pause() {
        let now = Date().timeIntervalSinceReferenceDate
        timerState.lastPausedElapsed = timerState.elapsed(at: now)
        timerState.isRunning = false
        saveTimerState()
        notificationService.cancelAllNotifications()
        Haptics.playLight()
    }
    
    func reset() {
        timerState.isRunning = false
        timerState.startedAt = nil
        timerState.accumulatedPause = 0
        timerState.lastPausedElapsed = 0
        saveTimerState()
        notificationService.cancelAllNotifications()
        Haptics.playMedium()
    }
    
    func nextPhase() {
        completePhase()
        Haptics.playMedium()
    }
    
    // MARK: - Phase Management
    private func completePhase() {
        let completedPhase = timerState.currentPhase
        
        // Update completed cycles count
        if completedPhase == .focus {
            timerState.completedFocusCycles += 1
        }
        
        // Determine next phase
        switch completedPhase {
        case .focus:
            // Check if it's time for long break
            if timerState.completedFocusCycles % settings.cyclesToLongBreak == 0 {
                timerState.currentPhase = .longBreak
            } else {
                timerState.currentPhase = .shortBreak
            }
        case .shortBreak, .longBreak:
            timerState.currentPhase = .focus
        }
        
        // Reset timer for next phase
        reset()
        
        // Auto-advance if enabled
        if settings.autoAdvance {
            start()
        }
        
        // Play haptic feedback
        Haptics.playSuccess()
    }
    
    func checkPhaseCompletion() {
        let now = Date().timeIntervalSinceReferenceDate
        if timerState.isRunning && timerState.isPhaseComplete(at: now, phaseDuration: currentPhaseDuration) {
            completePhase()
        }
    }
    
    // MARK: - Settings Presets
    func applyPreset(_ preset: PomodoroSettings) {
        settings = preset
        reset()
    }
    
    func updateAccentColor(_ color: Color) {
        if let hex = color.toHex() {
            settings.accentColorHex = hex
        }
    }
    
    // MARK: - Persistence
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "pomodoroSettings")
        }
    }
    
    private func saveTimerState() {
        if let encoded = try? JSONEncoder().encode(timerState) {
            UserDefaults.standard.set(encoded, forKey: "pomodoroTimerState")
        }
    }
    
    // MARK: - Notifications
    private func schedulePhaseNotification() {
        notificationService.cancelAllNotifications()
        let remainingTime = remaining
        if remainingTime > 0 {
            notificationService.schedulePhaseNotification(
                phase: timerState.currentPhase,
                timeInterval: remainingTime
            )
        }
    }
}
