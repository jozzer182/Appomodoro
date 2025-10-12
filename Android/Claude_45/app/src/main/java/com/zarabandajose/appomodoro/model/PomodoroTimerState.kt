package com.zarabandajose.appomodoro.model

data class PomodoroTimerState(
    val currentPhase: PomodoroPhase = PomodoroPhase.FOCUS,
    val isRunning: Boolean = false,
    val isPaused: Boolean = false,
    val remainingSeconds: Double = 25.0 * 60.0,
    val totalSeconds: Double = 25.0 * 60.0,
    val completedFocusCycles: Int = 0,
    val startTimeMillis: Long? = null,
    val pausedAtMillis: Long? = null,
    val totalPausedMillis: Long = 0L
) {
    val elapsedSeconds: Double
        get() = totalSeconds - remainingSeconds
    
    val minutes: Int
        get() = (remainingSeconds / 60.0).toInt()
    
    val seconds: Int
        get() = (remainingSeconds % 60.0).toInt()
}
