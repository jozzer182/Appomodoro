package com.zarabandajose.appomodoro.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.R

@Composable
fun ControlBar(
    isRunning: Boolean,
    isPaused: Boolean,
    onStartClick: () -> Unit,
    onPauseClick: () -> Unit,
    onResetClick: () -> Unit,
    onNextPhaseClick: () -> Unit,
    accentColor: Color,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Reset button
        IconButton(
            onClick = onResetClick,
            modifier = Modifier.size(56.dp)
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_refresh),
                contentDescription = "Reset",
                tint = Color(0xFF9AA0A6),
                modifier = Modifier.size(28.dp)
            )
        }
        
        Spacer(modifier = Modifier.width(8.dp))
        
        // Main play/pause button
        FilledTonalButton(
            onClick = if (isRunning) onPauseClick else onStartClick,
            modifier = Modifier
                .size(72.dp),
            colors = ButtonDefaults.filledTonalButtonColors(
                containerColor = accentColor,
                contentColor = Color.White
            ),
            shape = androidx.compose.foundation.shape.CircleShape
        ) {
            Icon(
                painter = if (isRunning) painterResource(id = R.drawable.ic_pause) else painterResource(id = android.R.drawable.ic_media_play),
                contentDescription = if (isRunning) "Pause" else "Start",
                modifier = Modifier.size(36.dp)
            )
        }
        
        Spacer(modifier = Modifier.width(8.dp))
        
        // Next phase button
        IconButton(
            onClick = onNextPhaseClick,
            modifier = Modifier.size(56.dp)
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_skip_next),
                contentDescription = "Next Phase",
                tint = Color(0xFF9AA0A6),
                modifier = Modifier.size(28.dp)
            )
        }
    }
}
