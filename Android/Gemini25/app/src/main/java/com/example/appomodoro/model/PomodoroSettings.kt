package com.example.appomodoro.model

import androidx.compose.ui.graphics.Color

data class PomodoroSettings(
    val focusDuration: Int = 25,
    val shortBreakDuration: Int = 5,
    val longBreakDuration: Int = 15,
    val longBreakInterval: Int = 4,
    val autoAdvance: Boolean = false,
    val notificationsEnabled: Boolean = true,
    val accentColor: Color = Color(0xFF7C4DFF)
)
