package com.zarabandajose.appomodoro.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.zarabandajose.appomodoro.model.PomodoroTimerState

@Composable
fun ControlBar(
    state: PomodoroTimerState,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit,
    onNext: () -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        if (!state.isRunning) {
            Button(onClick = onStart) { Text("Start") }
        } else if (state.isPaused) {
            Button(onClick = onResume) { Text("Resume") }
        } else {
            Button(onClick = onPause) { Text("Pause") }
        }
        Button(onClick = onReset) { Text("Reset") }
        Button(onClick = onNext) { Text("Next") }
    }
}