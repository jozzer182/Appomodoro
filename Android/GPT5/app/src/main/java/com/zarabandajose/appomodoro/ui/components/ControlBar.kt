package com.zarabandajose.appomodoro.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Pause
import androidx.compose.material.icons.outlined.PlayArrow
import androidx.compose.material.icons.outlined.RestartAlt
import androidx.compose.material.icons.outlined.SkipNext
import androidx.compose.material3.Button
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.R

@Composable
fun ControlBar(
    isRunning: Boolean,
    isPaused: Boolean,
    hasStarted: Boolean,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit,
    onSkip: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        val primaryLabel = when {
            !hasStarted -> stringResource(id = R.string.control_start)
            isRunning -> stringResource(id = R.string.control_pause)
            isPaused -> stringResource(id = R.string.control_resume)
            else -> stringResource(id = R.string.control_start)
        }
        val primaryIcon = when {
            !hasStarted -> Icons.Outlined.PlayArrow
            isRunning -> Icons.Outlined.Pause
            isPaused -> Icons.Outlined.PlayArrow
            else -> Icons.Outlined.PlayArrow
        }
        Button(
            onClick = when {
                !hasStarted -> onStart
                isRunning -> onPause
                isPaused -> onResume
                else -> onStart
            },
            modifier = Modifier.weight(1f)
        ) {
            ControlButtonContent(icon = primaryIcon, label = primaryLabel)
        }

        OutlinedButton(
            onClick = onReset,
            modifier = Modifier.weight(1f)
        ) {
            ControlButtonContent(
                icon = Icons.Outlined.RestartAlt,
                label = stringResource(id = R.string.control_reset)
            )
        }

        FilledTonalButton(
            onClick = onSkip,
            modifier = Modifier.weight(1f)
        ) {
            ControlButtonContent(
                icon = Icons.Outlined.SkipNext,
                label = stringResource(id = R.string.control_next)
            )
        }
    }
}

@Composable
private fun ControlButtonContent(icon: ImageVector, label: String) {
    Icon(imageVector = icon, contentDescription = label, tint = Color.Unspecified)
    Spacer(modifier = Modifier.width(8.dp))
    Text(text = label)
}
