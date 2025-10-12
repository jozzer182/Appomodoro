package com.zarabandajose.appomodoro.model

import androidx.compose.ui.graphics.Color

data class PomodoroSettings(
    val focusMinutes: Int,
    val shortBreakMinutes: Int,
    val longBreakMinutes: Int,
    val customMinutes: Int,
    val autoAdvance: Boolean,
    val notificationsEnabled: Boolean,
    val accentColor: Int
) {
    fun accentColorAsColor(): Color = Color(accentColor)

    companion object {
        private const val DEFAULT_FOCUS = 25
        private const val DEFAULT_SHORT_BREAK = 5
        private const val DEFAULT_LONG_BREAK = 15
        private const val DEFAULT_CUSTOM = 20
        private const val DEFAULT_ACCENT = 0xFF7C4DFF.toInt()

        val Default = PomodoroSettings(
            focusMinutes = DEFAULT_FOCUS,
            shortBreakMinutes = DEFAULT_SHORT_BREAK,
            longBreakMinutes = DEFAULT_LONG_BREAK,
            customMinutes = DEFAULT_CUSTOM,
            autoAdvance = true,
            notificationsEnabled = true,
            accentColor = DEFAULT_ACCENT
        )
    }
}
