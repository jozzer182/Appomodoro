package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.ui.PomodoroViewModel
import com.zarabandajose.appomodoro.ui.components.ControlBar
import com.zarabandajose.appomodoro.ui.components.DialCanvas

@Composable
fun HomeScreen(
    viewModel: PomodoroViewModel,
    onNavigateToSettings: () -> Unit,
    modifier: Modifier = Modifier
) {
    val timerState by viewModel.timerState.collectAsState()
    val settings by viewModel.settings.collectAsState()
    
    val accentColor = Color(settings.accentColor)
    
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Color(0xFF111214))
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Top bar with phase name and settings button
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = timerState.currentPhase.displayName,
                    style = MaterialTheme.typography.headlineMedium,
                    color = Color(0xFFE8EAED),
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "Cycle ${timerState.completedFocusCycles + 1}",
                    style = MaterialTheme.typography.bodyMedium,
                    color = Color(0xFF9AA0A6)
                )
            }
            
            IconButton(onClick = onNavigateToSettings) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_settings),
                    contentDescription = "Settings",
                    tint = Color(0xFF9AA0A6)
                )
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Dial canvas
        Box(
            modifier = Modifier
                .weight(1f)
                .aspectRatio(1f)
                .padding(16.dp)
        ) {
            DialCanvas(
                elapsedSeconds = timerState.elapsedSeconds,
                remainingMinutes = timerState.minutes,
                remainingSeconds = timerState.seconds,
                accentColor = accentColor
            )
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Status text
        Text(
            text = if (timerState.isRunning) "Running" else if (timerState.isPaused) "Paused" else "Ready",
            style = MaterialTheme.typography.bodyLarge,
            color = if (timerState.isRunning) accentColor else Color(0xFF9AA0A6),
            modifier = Modifier.padding(bottom = 16.dp)
        )
        
        // Control bar
        ControlBar(
            isRunning = timerState.isRunning,
            isPaused = timerState.isPaused,
            onStartClick = { viewModel.startTimer() },
            onPauseClick = { viewModel.pauseTimer() },
            onResetClick = { viewModel.resetTimer() },
            onNextPhaseClick = { viewModel.nextPhase() },
            accentColor = accentColor
        )
        
        Spacer(modifier = Modifier.height(16.dp))
    }
}
