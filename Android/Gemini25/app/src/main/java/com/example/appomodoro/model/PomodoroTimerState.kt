package com.example.appomodoro.model

data class PomodoroTimerState(
    val phase: PomodoroPhase = PomodoroPhase.FOCUS,
    val remainingTime: Long = 25 * 60 * 1000,
    val totalTime: Long = 25 * 60 * 1000,
    val isRunning: Boolean = false,
    val sessionCount: Int = 0
)
