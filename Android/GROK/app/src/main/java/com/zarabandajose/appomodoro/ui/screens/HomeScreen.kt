package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import com.zarabandajose.appomodoro.ui.components.ControlBar
import com.zarabandajose.appomodoro.ui.components.DialCanvas
import kotlinx.coroutines.isActive

@Composable
fun HomeScreen(
    state: PomodoroTimerState,
    elapsedSec: Double,
    accentColor: Color,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit,
    onNext: () -> Unit,
    onUpdateElapsed: (Long) -> Unit
) {
    LaunchedEffect(state.isRunning, state.isPaused) {
        while (isActive && state.isRunning && !state.isPaused) {
            kotlinx.coroutines.delay(16) // ~60 fps
            onUpdateElapsed(System.currentTimeMillis())
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = state.currentPhase.name, style = MaterialTheme.typography.headlineMedium)

        Spacer(modifier = Modifier.height(32.dp))

        DialCanvas(elapsedSec = elapsedSec, accentColor = accentColor)

        Spacer(modifier = Modifier.height(32.dp))

        ControlBar(
            state = state,
            onStart = onStart,
            onPause = onPause,
            onResume = onResume,
            onReset = onReset,
            onNext = onNext
        )
    }
}