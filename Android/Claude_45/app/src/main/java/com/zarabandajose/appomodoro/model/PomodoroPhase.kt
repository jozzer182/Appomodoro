package com.zarabandajose.appomodoro.model

enum class PomodoroPhase(val displayName: String, val defaultDurationSeconds: Int) {
    FOCUS("Focus", 25 * 60),
    SHORT_BREAK("Short Break", 5 * 60),
    LONG_BREAK("Long Break", 15 * 60),
    CUSTOM("Custom", 10 * 60)
}
