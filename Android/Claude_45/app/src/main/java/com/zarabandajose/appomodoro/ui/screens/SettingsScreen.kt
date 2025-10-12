package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.ui.PomodoroViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    viewModel: PomodoroViewModel,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    val settings by viewModel.settings.collectAsState()
    
    var focusDuration by remember(settings.focusDurationMinutes) {
        mutableStateOf(settings.focusDurationMinutes.toString())
    }
    var shortBreakDuration by remember(settings.shortBreakDurationMinutes) {
        mutableStateOf(settings.shortBreakDurationMinutes.toString())
    }
    var longBreakDuration by remember(settings.longBreakDurationMinutes) {
        mutableStateOf(settings.longBreakDurationMinutes.toString())
    }
    var cyclesBeforeLongBreak by remember(settings.cyclesBeforeLongBreak) {
        mutableStateOf(settings.cyclesBeforeLongBreak.toString())
    }
    var autoAdvance by remember(settings.autoAdvancePhases) {
        mutableStateOf(settings.autoAdvancePhases)
    }
    var enableNotifications by remember(settings.enableNotifications) {
        mutableStateOf(settings.enableNotifications)
    }
    var selectedAccentColor by remember(settings.accentColor) {
        mutableStateOf(settings.accentColor)
    }
    
    val accentColors = listOf(
        0xFF7C4DFF to "Blue Violet",
        0xFFFF4081 to "Pink",
        0xFF00BCD4 to "Cyan",
        0xFF4CAF50 to "Green",
        0xFFFF9800 to "Orange",
        0xFFF44336 to "Red",
        0xFF9C27B0 to "Purple",
        0xFFFFEB3B to "Yellow"
    )
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Settings") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_arrow_back),
                            contentDescription = "Back"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color(0xFF1E1F22),
                    titleContentColor = Color(0xFFE8EAED),
                    navigationIconContentColor = Color(0xFFE8EAED)
                )
            )
        },
        containerColor = Color(0xFF111214)
    ) { paddingValues ->
        Column(
            modifier = modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Presets section
            Text(
                text = "Presets",
                style = MaterialTheme.typography.titleMedium,
                color = Color(0xFFE8EAED),
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Button(
                    onClick = {
                        focusDuration = "25"
                        shortBreakDuration = "5"
                        longBreakDuration = "15"
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("25/5")
                }
                
                Button(
                    onClick = {
                        focusDuration = "50"
                        shortBreakDuration = "10"
                        longBreakDuration = "20"
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("50/10")
                }
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Duration settings
            Text(
                text = "Durations (minutes)",
                style = MaterialTheme.typography.titleMedium,
                color = Color(0xFFE8EAED),
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            OutlinedTextField(
                value = focusDuration,
                onValueChange = { focusDuration = it },
                label = { Text("Focus Duration") },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = Color(0xFFE8EAED),
                    unfocusedTextColor = Color(0xFFE8EAED),
                    focusedBorderColor = Color(selectedAccentColor),
                    unfocusedBorderColor = Color(0xFF5F6368),
                    focusedLabelColor = Color(selectedAccentColor),
                    unfocusedLabelColor = Color(0xFF9AA0A6)
                )
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            OutlinedTextField(
                value = shortBreakDuration,
                onValueChange = { shortBreakDuration = it },
                label = { Text("Short Break Duration") },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = Color(0xFFE8EAED),
                    unfocusedTextColor = Color(0xFFE8EAED),
                    focusedBorderColor = Color(selectedAccentColor),
                    unfocusedBorderColor = Color(0xFF5F6368),
                    focusedLabelColor = Color(selectedAccentColor),
                    unfocusedLabelColor = Color(0xFF9AA0A6)
                )
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            OutlinedTextField(
                value = longBreakDuration,
                onValueChange = { longBreakDuration = it },
                label = { Text("Long Break Duration") },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = Color(0xFFE8EAED),
                    unfocusedTextColor = Color(0xFFE8EAED),
                    focusedBorderColor = Color(selectedAccentColor),
                    unfocusedBorderColor = Color(0xFF5F6368),
                    focusedLabelColor = Color(selectedAccentColor),
                    unfocusedLabelColor = Color(0xFF9AA0A6)
                )
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            OutlinedTextField(
                value = cyclesBeforeLongBreak,
                onValueChange = { cyclesBeforeLongBreak = it },
                label = { Text("Cycles Before Long Break") },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = Color(0xFFE8EAED),
                    unfocusedTextColor = Color(0xFFE8EAED),
                    focusedBorderColor = Color(selectedAccentColor),
                    unfocusedBorderColor = Color(0xFF5F6368),
                    focusedLabelColor = Color(selectedAccentColor),
                    unfocusedLabelColor = Color(0xFF9AA0A6)
                )
            )
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Toggles
            Text(
                text = "Options",
                style = MaterialTheme.typography.titleMedium,
                color = Color(0xFFE8EAED),
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Auto-advance phases", color = Color(0xFFE8EAED))
                Switch(
                    checked = autoAdvance,
                    onCheckedChange = { autoAdvance = it },
                    colors = SwitchDefaults.colors(
                        checkedThumbColor = Color.White,
                        checkedTrackColor = Color(selectedAccentColor)
                    )
                )
            }
            
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Enable notifications", color = Color(0xFFE8EAED))
                Switch(
                    checked = enableNotifications,
                    onCheckedChange = { enableNotifications = it },
                    colors = SwitchDefaults.colors(
                        checkedThumbColor = Color.White,
                        checkedTrackColor = Color(selectedAccentColor)
                    )
                )
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Accent color picker
            Text(
                text = "Accent Color",
                style = MaterialTheme.typography.titleMedium,
                color = Color(0xFFE8EAED),
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                accentColors.chunked(4).forEach { row ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        row.forEach { (colorValue, _) ->
                            Box(
                                modifier = Modifier
                                    .size(48.dp)
                                    .background(Color(colorValue), CircleShape)
                                    .border(
                                        width = if (selectedAccentColor == colorValue) 3.dp else 0.dp,
                                        color = Color.White,
                                        shape = CircleShape
                                    )
                                    .clickable { selectedAccentColor = colorValue }
                            )
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
            
            // Save button
            Button(
                onClick = {
                    val newSettings = PomodoroSettings(
                        focusDurationMinutes = focusDuration.toIntOrNull() ?: 25,
                        shortBreakDurationMinutes = shortBreakDuration.toIntOrNull() ?: 5,
                        longBreakDurationMinutes = longBreakDuration.toIntOrNull() ?: 15,
                        cyclesBeforeLongBreak = cyclesBeforeLongBreak.toIntOrNull() ?: 4,
                        autoAdvancePhases = autoAdvance,
                        enableNotifications = enableNotifications,
                        accentColor = selectedAccentColor
                    )
                    viewModel.updateSettings(newSettings)
                    onNavigateBack()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(selectedAccentColor)
                )
            ) {
                Text("Save Settings", color = Color.White)
            }
        }
    }
}
