package com.example.appomodoro.data

import android.content.Context
import androidx.compose.ui.graphics.Color
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.example.appomodoro.model.PomodoroSettings
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

class SettingsStore(private val context: Context) {

    private object PreferencesKeys {
        val FOCUS_DURATION = intPreferencesKey("focus_duration")
        val SHORT_BREAK_DURATION = intPreferencesKey("short_break_duration")
        val LONG_BREAK_DURATION = intPreferencesKey("long_break_duration")
        val LONG_BREAK_INTERVAL = intPreferencesKey("long_break_interval")
        val AUTO_ADVANCE = booleanPreferencesKey("auto_advance")
        val NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")
        val ACCENT_COLOR = longPreferencesKey("accent_color")
    }

    val settingsFlow: Flow<PomodoroSettings> = context.dataStore.data.map { preferences ->
        PomodoroSettings(
            focusDuration = preferences[PreferencesKeys.FOCUS_DURATION] ?: 25,
            shortBreakDuration = preferences[PreferencesKeys.SHORT_BREAK_DURATION] ?: 5,
            longBreakDuration = preferences[PreferencesKeys.LONG_BREAK_DURATION] ?: 15,
            longBreakInterval = preferences[PreferencesKeys.LONG_BREAK_INTERVAL] ?: 4,
            autoAdvance = preferences[PreferencesKeys.AUTO_ADVANCE] ?: false,
            notificationsEnabled = preferences[PreferencesKeys.NOTIFICATIONS_ENABLED] ?: true,
            accentColor = Color(preferences[PreferencesKeys.ACCENT_COLOR] ?: 0xFF7C4DFF)
        )
    }

    suspend fun saveSettings(settings: PomodoroSettings) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.FOCUS_DURATION] = settings.focusDuration
            preferences[PreferencesKeys.SHORT_BREAK_DURATION] = settings.shortBreakDuration
            preferences[PreferencesKeys.LONG_BREAK_DURATION] = settings.longBreakDuration
            preferences[PreferencesKeys.LONG_BREAK_INTERVAL] = settings.longBreakInterval
            preferences[PreferencesKeys.AUTO_ADVANCE] = settings.autoAdvance
            preferences[PreferencesKeys.NOTIFICATIONS_ENABLED] = settings.notificationsEnabled
            preferences[PreferencesKeys.ACCENT_COLOR] = settings.accentColor.value.toLong()
        }
    }
}
