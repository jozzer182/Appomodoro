package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.model.PomodoroSettings
import kotlin.math.max

@Composable
fun SettingsScreen(
    settings: PomodoroSettings,
    onDurationsChange: (focus: Int, short: Int, long: Int, custom: Int) -> Unit,
    onAccentSelected: (Int) -> Unit,
    onAutoAdvanceChanged: (Boolean) -> Unit,
    onNotificationsChanged: (Boolean) -> Unit,
    onRequestNotificationPermission: () -> Unit,
    canScheduleExactAlarm: Boolean,
    onOpenExactAlarmSettings: () -> Unit,
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()
    var focusMinutes by rememberSaveable { mutableStateOf(settings.focusMinutes.toString()) }
    var shortMinutes by rememberSaveable { mutableStateOf(settings.shortBreakMinutes.toString()) }
    var longMinutes by rememberSaveable { mutableStateOf(settings.longBreakMinutes.toString()) }
    var customMinutes by rememberSaveable { mutableStateOf(settings.customMinutes.toString()) }

    LaunchedEffect(settings.focusMinutes, settings.shortBreakMinutes, settings.longBreakMinutes, settings.customMinutes) {
        focusMinutes = settings.focusMinutes.toString()
        shortMinutes = settings.shortBreakMinutes.toString()
        longMinutes = settings.longBreakMinutes.toString()
        customMinutes = settings.customMinutes.toString()
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = stringResource(id = R.string.settings_title),
            style = MaterialTheme.typography.headlineSmall
        )

        DurationField(
            label = stringResource(id = R.string.settings_focus_minutes),
            value = focusMinutes,
            onValueChange = { focusMinutes = filterDigits(it) }
        )
        DurationField(
            label = stringResource(id = R.string.settings_short_break_minutes),
            value = shortMinutes,
            onValueChange = { shortMinutes = filterDigits(it) }
        )
        DurationField(
            label = stringResource(id = R.string.settings_long_break_minutes),
            value = longMinutes,
            onValueChange = { longMinutes = filterDigits(it) }
        )
        DurationField(
            label = stringResource(id = R.string.settings_custom_minutes),
            value = customMinutes,
            onValueChange = { customMinutes = filterDigits(it) }
        )

        Button(
            onClick = {
                val focus = max(1, focusMinutes.toIntOrNull() ?: settings.focusMinutes)
                val short = max(1, shortMinutes.toIntOrNull() ?: settings.shortBreakMinutes)
                val long = max(1, longMinutes.toIntOrNull() ?: settings.longBreakMinutes)
                val custom = max(1, customMinutes.toIntOrNull() ?: settings.customMinutes)
                onDurationsChange(focus, short, long, custom)
            }
        ) {
            Text(text = stringResource(id = R.string.settings_save_durations))
        }

        Surface(tonalElevation = 2.dp, shape = MaterialTheme.shapes.medium) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(text = stringResource(id = R.string.settings_accent_label), style = MaterialTheme.typography.titleMedium)
                ColorPalette(
                    selectedColor = settings.accentColor,
                    onAccentSelected = onAccentSelected
                )
            }
        }

        SettingToggle(
            title = stringResource(id = R.string.settings_auto_advance_title),
            description = stringResource(id = R.string.settings_auto_advance_summary),
            checked = settings.autoAdvance,
            onCheckedChange = onAutoAdvanceChanged
        )

        SettingToggle(
            title = stringResource(id = R.string.settings_notifications_title),
            description = stringResource(id = R.string.settings_notifications_summary),
            checked = settings.notificationsEnabled,
            onCheckedChange = { enabled ->
                if (enabled) {
                    onRequestNotificationPermission()
                }
                onNotificationsChanged(enabled)
            }
        )

        if (!canScheduleExactAlarm) {
            Surface(tonalElevation = 1.dp, shape = MaterialTheme.shapes.medium, color = MaterialTheme.colorScheme.surfaceVariant) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        text = stringResource(id = R.string.settings_exact_alarm_warning),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Button(onClick = onOpenExactAlarmSettings) {
                        Text(text = stringResource(id = R.string.settings_open_exact_alarm))
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(24.dp))
    }
}

@Composable
private fun DurationField(
    label: String,
    value: String,
    onValueChange: (String) -> Unit
) {
    OutlinedTextField(
        value = value,
        onValueChange = onValueChange,
        label = { Text(text = label) },
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
        singleLine = true,
        modifier = Modifier.fillMaxWidth()
    )
}

@Composable
private fun SettingToggle(
    title: String,
    description: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Surface(tonalElevation = 2.dp, shape = MaterialTheme.shapes.medium) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Text(text = title, style = MaterialTheme.typography.titleMedium)
            Text(text = description, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Switch(
                checked = checked,
                onCheckedChange = onCheckedChange,
                colors = SwitchDefaults.colors(
                    checkedTrackColor = MaterialTheme.colorScheme.primary,
                    checkedThumbColor = Color.White
                )
            )
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun ColorPalette(
    selectedColor: Int,
    onAccentSelected: (Int) -> Unit
) {
    val palette = remember {
        listOf(
            0xFF7C4DFF.toInt(),
            0xFF00BCD4.toInt(),
            0xFFFF7043.toInt(),
            0xFFFFC107.toInt(),
            0xFF26C6DA.toInt(),
            0xFF66BB6A.toInt()
        )
    }
    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        palette.forEach { colorInt ->
            val selected = colorInt == selectedColor
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .background(Color(colorInt), CircleShape)
                    .border(
                        width = if (selected) 3.dp else 1.dp,
                        color = if (selected) Color.White else MaterialTheme.colorScheme.outlineVariant,
                        shape = CircleShape
                    )
                    .clickable { onAccentSelected(colorInt) }
            )
        }
    }
}

private fun filterDigits(input: String): String = input.filter { it.isDigit() }
