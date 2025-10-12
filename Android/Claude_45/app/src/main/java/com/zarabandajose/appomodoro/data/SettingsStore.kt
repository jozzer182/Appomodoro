package com.zarabandajose.appomodoro.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.zarabandajose.appomodoro.model.PomodoroSettings
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "pomodoro_settings")

class SettingsStore(private val context: Context) {
    
    companion object {
        private val FOCUS_DURATION = intPreferencesKey("focus_duration")
        private val SHORT_BREAK_DURATION = intPreferencesKey("short_break_duration")
        private val LONG_BREAK_DURATION = intPreferencesKey("long_break_duration")
        private val CYCLES_BEFORE_LONG_BREAK = intPreferencesKey("cycles_before_long_break")
        private val AUTO_ADVANCE = booleanPreferencesKey("auto_advance")
        private val ENABLE_NOTIFICATIONS = booleanPreferencesKey("enable_notifications")
        private val ACCENT_COLOR = longPreferencesKey("accent_color")
    }
    
    val settingsFlow: Flow<PomodoroSettings> = context.dataStore.data.map { preferences ->
        PomodoroSettings(
            focusDurationMinutes = preferences[FOCUS_DURATION] ?: 25,
            shortBreakDurationMinutes = preferences[SHORT_BREAK_DURATION] ?: 5,
            longBreakDurationMinutes = preferences[LONG_BREAK_DURATION] ?: 15,
            cyclesBeforeLongBreak = preferences[CYCLES_BEFORE_LONG_BREAK] ?: 4,
            autoAdvancePhases = preferences[AUTO_ADVANCE] ?: false,
            enableNotifications = preferences[ENABLE_NOTIFICATIONS] ?: true,
            accentColor = preferences[ACCENT_COLOR] ?: 0xFF7C4DFF
        )
    }
    
    suspend fun updateSettings(settings: PomodoroSettings) {
        context.dataStore.edit { preferences ->
            preferences[FOCUS_DURATION] = settings.focusDurationMinutes
            preferences[SHORT_BREAK_DURATION] = settings.shortBreakDurationMinutes
            preferences[LONG_BREAK_DURATION] = settings.longBreakDurationMinutes
            preferences[CYCLES_BEFORE_LONG_BREAK] = settings.cyclesBeforeLongBreak
            preferences[AUTO_ADVANCE] = settings.autoAdvancePhases
            preferences[ENABLE_NOTIFICATIONS] = settings.enableNotifications
            preferences[ACCENT_COLOR] = settings.accentColor
        }
    }
}
