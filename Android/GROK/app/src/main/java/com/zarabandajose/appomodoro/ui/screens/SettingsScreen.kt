package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.model.PomodoroSettings

@Composable
fun SettingsScreen(
    settings: PomodoroSettings,
    onSettingsChange: (PomodoroSettings) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Settings", style = MaterialTheme.typography.headlineMedium)

        Spacer(modifier = Modifier.height(16.dp))

        // Focus minutes
        OutlinedTextField(
            value = settings.focusMinutes.toString(),
            onValueChange = { onSettingsChange(settings.copy(focusMinutes = it.toIntOrNull() ?: 25)) },
            label = { Text("Focus Minutes") }
        )

        // Short break
        OutlinedTextField(
            value = settings.shortBreakMinutes.toString(),
            onValueChange = { onSettingsChange(settings.copy(shortBreakMinutes = it.toIntOrNull() ?: 5)) },
            label = { Text("Short Break Minutes") }
        )

        // Long break
        OutlinedTextField(
            value = settings.longBreakMinutes.toString(),
            onValueChange = { onSettingsChange(settings.copy(longBreakMinutes = it.toIntOrNull() ?: 15)) },
            label = { Text("Long Break Minutes") }
        )

        // Custom
        OutlinedTextField(
            value = settings.customMinutes.toString(),
            onValueChange = { onSettingsChange(settings.copy(customMinutes = it.toIntOrNull() ?: 10)) },
            label = { Text("Custom Minutes") }
        )

        // Auto advance
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(
                checked = settings.autoAdvance,
                onCheckedChange = { onSettingsChange(settings.copy(autoAdvance = it)) }
            )
            Text("Auto Advance")
        }

        // Notifications
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(
                checked = settings.notificationsEnabled,
                onCheckedChange = { onSettingsChange(settings.copy(notificationsEnabled = it)) }
            )
            Text("Enable Notifications")
        }
    }
}