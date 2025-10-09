package com.example.appomodoro.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.appomodoro.domain.PomodoroEngine
import com.example.appomodoro.ui.components.ControlBar
import com.example.appomodoro.ui.components.DialCanvas

@Composable
fun HomeScreen(pomodoroEngine: PomodoroEngine) {
    val timerState by pomodoroEngine.timerState.collectAsState()
    val settings by pomodoroEngine.settings.collectAsState()

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = timerState.phase.name, modifier = Modifier.padding(16.dp))
        DialCanvas(
            timerState = timerState,
            accentColor = settings.accentColor
        )
        ControlBar(
            isRunning = timerState.isRunning,
            onStart = { pomodoroEngine.startTimer() },
            onPause = { pomodoroEngine.pauseTimer() },
            onResume = { pomodoroEngine.resumeTimer() },
            onReset = { pomodoroEngine.resetTimer() },
            onNext = { pomodoroEngine.nextPhase() }
        )
    }
}
