package com.zarabandajose.appomodoro.data

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.zarabandajose.appomodoro.model.PomodoroSettings
import java.io.IOException
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import androidx.datastore.preferences.core.emptyPreferences

private const val DATA_STORE_NAME = "pomodoro_settings"

private val Context.settingsDataStore by preferencesDataStore(name = DATA_STORE_NAME)

class SettingsStore(private val context: Context) {

    val settingsFlow: Flow<PomodoroSettings> = context.settingsDataStore.data
        .catch { throwable ->
            if (throwable is IOException) emit(emptyPreferences()) else throw throwable
        }
        .map { preferences ->
            PomodoroSettings(
                focusMinutes = preferences[FOCUS_MINUTES]?.coerceAtLeast(1) ?: PomodoroSettings.Default.focusMinutes,
                shortBreakMinutes = preferences[SHORT_BREAK_MINUTES]?.coerceAtLeast(1)
                    ?: PomodoroSettings.Default.shortBreakMinutes,
                longBreakMinutes = preferences[LONG_BREAK_MINUTES]?.coerceAtLeast(1)
                    ?: PomodoroSettings.Default.longBreakMinutes,
                customMinutes = preferences[CUSTOM_MINUTES]?.coerceAtLeast(1)
                    ?: PomodoroSettings.Default.customMinutes,
                autoAdvance = preferences[AUTO_ADVANCE] ?: PomodoroSettings.Default.autoAdvance,
                notificationsEnabled = preferences[NOTIFICATIONS_ENABLED]
                    ?: PomodoroSettings.Default.notificationsEnabled,
                accentColor = preferences[ACCENT_COLOR] ?: PomodoroSettings.Default.accentColor
            )
        }

    suspend fun updateDurations(
        focusMinutes: Int,
        shortBreakMinutes: Int,
        longBreakMinutes: Int,
        customMinutes: Int
    ) {
        context.settingsDataStore.edit { prefs ->
            prefs[FOCUS_MINUTES] = focusMinutes.coerceIn(1, 180)
            prefs[SHORT_BREAK_MINUTES] = shortBreakMinutes.coerceIn(1, 60)
            prefs[LONG_BREAK_MINUTES] = longBreakMinutes.coerceIn(5, 60)
            prefs[CUSTOM_MINUTES] = customMinutes.coerceIn(1, 180)
        }
    }

    suspend fun updateAccentColor(color: Int) {
        context.settingsDataStore.edit { prefs ->
            prefs[ACCENT_COLOR] = color
        }
    }

    suspend fun updateAutoAdvance(enabled: Boolean) {
        context.settingsDataStore.edit { prefs ->
            prefs[AUTO_ADVANCE] = enabled
        }
    }

    suspend fun updateNotificationsEnabled(enabled: Boolean) {
        context.settingsDataStore.edit { prefs ->
            prefs[NOTIFICATIONS_ENABLED] = enabled
        }
    }

    private companion object {
        val FOCUS_MINUTES = intPreferencesKey("focus_minutes")
        val SHORT_BREAK_MINUTES = intPreferencesKey("short_break_minutes")
        val LONG_BREAK_MINUTES = intPreferencesKey("long_break_minutes")
        val CUSTOM_MINUTES = intPreferencesKey("custom_minutes")
        val AUTO_ADVANCE = booleanPreferencesKey("auto_advance")
        val NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")
        val ACCENT_COLOR = intPreferencesKey("accent_color")
    }
}
