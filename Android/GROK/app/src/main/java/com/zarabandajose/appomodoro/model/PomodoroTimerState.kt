package com.zarabandajose.appomodoro.model

data class PomodoroTimerState(
    val currentPhase: PomodoroPhase = PomodoroPhase.Focus,
    val isRunning: Boolean = false,
    val isPaused: Boolean = false,
    val remainingSeconds: Int = 25 * 60,
    val totalSeconds: Int = 25 * 60,
    val startTime: Long = 0L,
    val pausedTime: Long = 0L,
    val cycleCount: Int = 0
)