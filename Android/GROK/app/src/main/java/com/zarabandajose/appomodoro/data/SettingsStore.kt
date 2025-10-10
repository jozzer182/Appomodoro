package com.zarabandajose.appomodoro.data

import android.content.Context
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import com.zarabandajose.appomodoro.model.PomodoroSettings
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore by preferencesDataStore(name = "pomodoro_settings")

class SettingsStore(val context: Context) {

    private val FOCUS_MINUTES = intPreferencesKey("focus_minutes")
    private val SHORT_BREAK_MINUTES = intPreferencesKey("short_break_minutes")
    private val LONG_BREAK_MINUTES = intPreferencesKey("long_break_minutes")
    private val CUSTOM_MINUTES = intPreferencesKey("custom_minutes")
    private val ACCENT_COLOR = intPreferencesKey("accent_color")
    private val AUTO_ADVANCE = booleanPreferencesKey("auto_advance")
    private val NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")

    val settingsFlow: Flow<PomodoroSettings> = context.dataStore.data.map { preferences ->
        PomodoroSettings(
            focusMinutes = preferences[FOCUS_MINUTES] ?: 25,
            shortBreakMinutes = preferences[SHORT_BREAK_MINUTES] ?: 5,
            longBreakMinutes = preferences[LONG_BREAK_MINUTES] ?: 15,
            customMinutes = preferences[CUSTOM_MINUTES] ?: 10,
            accentColor = preferences[ACCENT_COLOR] ?: 0xFF7C4DFF.toInt(),
            autoAdvance = preferences[AUTO_ADVANCE] ?: false,
            notificationsEnabled = preferences[NOTIFICATIONS_ENABLED] ?: true
        )
    }

    suspend fun saveSettings(settings: PomodoroSettings) {
        context.dataStore.edit { preferences ->
            preferences[FOCUS_MINUTES] = settings.focusMinutes
            preferences[SHORT_BREAK_MINUTES] = settings.shortBreakMinutes
            preferences[LONG_BREAK_MINUTES] = settings.longBreakMinutes
            preferences[CUSTOM_MINUTES] = settings.customMinutes
            preferences[ACCENT_COLOR] = settings.accentColor
            preferences[AUTO_ADVANCE] = settings.autoAdvance
            preferences[NOTIFICATIONS_ENABLED] = settings.notificationsEnabled
        }
    }
}