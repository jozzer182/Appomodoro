package com.zarabandajose.appomodoro.domain

import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import kotlin.math.max

class PomodoroEngine(private val settings: PomodoroSettings) {

    fun getNextPhase(currentPhase: PomodoroPhase, cycleCount: Int): PomodoroPhase {
        return when (currentPhase) {
            PomodoroPhase.Focus -> {
                if (cycleCount % 4 == 0) PomodoroPhase.LongBreak else PomodoroPhase.ShortBreak
            }
            PomodoroPhase.ShortBreak, PomodoroPhase.LongBreak -> PomodoroPhase.Focus
            PomodoroPhase.Custom -> PomodoroPhase.Focus // or stay, but for now
        }
    }

    fun getDurationForPhase(phase: PomodoroPhase): Int {
        return when (phase) {
            PomodoroPhase.Focus -> settings.focusMinutes * 60
            PomodoroPhase.ShortBreak -> settings.shortBreakMinutes * 60
            PomodoroPhase.LongBreak -> settings.longBreakMinutes * 60
            PomodoroPhase.Custom -> settings.customMinutes * 60
        }
    }

    fun calculateElapsedSeconds(state: PomodoroTimerState, currentTime: Long): Double {
        if (!state.isRunning || state.isPaused) return 0.0
        val elapsed = (currentTime - state.startTime) / 1000.0
        return max(0.0, elapsed - state.pausedTime / 1000.0)
    }

    fun calculateRemainingSeconds(state: PomodoroTimerState, elapsed: Double): Int {
        return max(0, state.totalSeconds - elapsed.toInt())
    }

    fun isPhaseEnded(state: PomodoroTimerState, elapsed: Double): Boolean {
        return elapsed >= state.totalSeconds
    }
}