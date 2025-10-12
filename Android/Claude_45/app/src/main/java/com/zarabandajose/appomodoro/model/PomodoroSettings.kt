package com.zarabandajose.appomodoro.model

import androidx.compose.ui.graphics.Color

data class PomodoroSettings(
    val focusDurationMinutes: Int = 25,
    val shortBreakDurationMinutes: Int = 5,
    val longBreakDurationMinutes: Int = 15,
    val cyclesBeforeLongBreak: Int = 4,
    val autoAdvancePhases: Boolean = false,
    val enableNotifications: Boolean = true,
    val accentColor: Long = 0xFF7C4DFF // Default blue-violet
)
