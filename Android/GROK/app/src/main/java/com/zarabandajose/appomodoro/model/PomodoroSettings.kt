package com.zarabandajose.appomodoro.model

data class PomodoroSettings(
    val focusMinutes: Int = 25,
    val shortBreakMinutes: Int = 5,
    val longBreakMinutes: Int = 15,
    val customMinutes: Int = 10,
    val accentColor: Int = 0xFF7C4DFF.toInt(),
    val autoAdvance: Boolean = false,
    val notificationsEnabled: Boolean = true
)