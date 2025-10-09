package com.example.appomodoro.ui.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun ControlBar(
    isRunning: Boolean,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit,
    onNext: () -> Unit
) {
    Row {
        if (isRunning) {
            Button(onClick = onPause) {
                Text("Pause")
            }
        } else {
            Button(onClick = onResume) {
                Text("Resume")
            }
            Spacer(modifier = Modifier.width(8.dp))
            Button(onClick = onStart) {
                Text("Start")
            }
        }
        Spacer(modifier = Modifier.width(8.dp))
        Button(onClick = onReset) {
            Text("Reset")
        }
        Spacer(modifier = Modifier.width(8.dp))
        Button(onClick = onNext) {
            Text("Next")
        }
    }
}
