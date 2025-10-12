package com.zarabandajose.appomodoro.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import com.zarabandajose.appomodoro.ui.components.ControlBar
import com.zarabandajose.appomodoro.ui.components.DialCanvas

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun HomeScreen(
    timerState: PomodoroTimerState,
    settings: PomodoroSettings,
    accentColor: Color,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit,
    onSkip: () -> Unit,
    onSelectPhase: (PomodoroPhase) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = stringResource(id = timerState.phase.labelRes),
            style = MaterialTheme.typography.headlineSmall,
            color = MaterialTheme.colorScheme.onBackground
        )
        Text(
            text = stringResource(
                id = R.string.focus_cycle_indicator,
                (timerState.focusSessionsCompleted % 4) + 1,
                timerState.focusSessionsCompleted
            ),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        FlowRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            AssistChip(
                onClick = {},
                enabled = false,
                label = {
                    Text(
                        text = if (settings.autoAdvance) {
                            stringResource(id = R.string.auto_advance_on)
                        } else {
                            stringResource(id = R.string.auto_advance_off)
                        }
                    )
                },
                colors = AssistChipDefaults.assistChipColors(
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledLabelColor = MaterialTheme.colorScheme.onSurfaceVariant
                )
            )
            AssistChip(
                onClick = {},
                enabled = false,
                label = {
                    Text(
                        text = if (settings.notificationsEnabled) {
                            stringResource(id = R.string.notifications_on)
                        } else {
                            stringResource(id = R.string.notifications_off)
                        }
                    )
                },
                colors = AssistChipDefaults.assistChipColors(
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledLabelColor = MaterialTheme.colorScheme.onSurfaceVariant
                )
            )
        }

        FlowRow(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            PomodoroPhase.values().forEach { phase ->
                FilterChip(
                    selected = timerState.phase == phase,
                    onClick = { onSelectPhase(phase) },
                    label = { Text(text = stringResource(id = phase.labelRes)) },
                    colors = FilterChipDefaults.filterChipColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant,
                        selectedContainerColor = accentColor.copy(alpha = 0.35f)
                    )
                )
            }
        }

        DialCanvas(
            timerState = timerState,
            accentColor = accentColor,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(8.dp))

        ControlBar(
            isRunning = timerState.isRunning,
            isPaused = timerState.isPaused,
            hasStarted = timerState.hasStarted,
            onStart = onStart,
            onPause = onPause,
            onResume = onResume,
            onReset = onReset,
            onSkip = onSkip,
            modifier = Modifier.fillMaxWidth()
        )
    }
}
