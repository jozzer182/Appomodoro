package com.zarabandajose.appomodoro.model

import androidx.annotation.StringRes
import com.zarabandajose.appomodoro.R

enum class PomodoroPhase(@StringRes val labelRes: Int) {
    Focus(R.string.phase_focus),
    ShortBreak(R.string.phase_short_break),
    LongBreak(R.string.phase_long_break),
    Custom(R.string.phase_custom);

    companion object {
        fun fromName(name: String?): PomodoroPhase = values().firstOrNull { it.name == name } ?: Focus
    }
}
