package com.zarabandajose.appomodoro.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.unit.dp
import com.zarabandajose.appomodoro.util.AngleMath
import kotlinx.coroutines.isActive

@Composable
fun DialCanvas(
    elapsedSec: Double,
    accentColor: Color,
    modifier: Modifier = Modifier
) {
    var currentElapsed by remember { mutableStateOf(elapsedSec) }

    LaunchedEffect(Unit) {
        while (isActive) {
            withFrameNanos { frameTime ->
                currentElapsed = elapsedSec // update from param
            }
        }
    }

    Canvas(modifier = modifier.size(300.dp)) {
        val center = Offset(size.width / 2, size.height / 2)
        val outerRadius = size.width / 2 - 20
        val innerRadius = outerRadius * 0.7f

        // Background
        drawCircle(Color(0xFF111214), radius = outerRadius)

        // Ticks (fixed)
        for (i in 0 until 60) {
            val angle = -Math.PI.toFloat() / 2 + 2 * Math.PI.toFloat() * i / 60
            val tickLength = if (i % 5 == 0) 10f else 5f
            val startRadius = outerRadius - tickLength
            val endRadius = outerRadius
            val start = AngleMath.positionOnCircle(center.x, center.y, startRadius, angle)
            val end = AngleMath.positionOnCircle(center.x, center.y, endRadius, angle)
            drawLine(color = Color.White, start = start, end = end, strokeWidth = 2f)
        }

        // Seconds ring rotation
        val secondsAngle = AngleMath.secondsAngle(currentElapsed)
        rotate(secondsAngle * 180 / Math.PI.toFloat(), center) {
            // Draw seconds numerals (simplified as dots)
            for (i in 0 until 60) {
                val angle = -Math.PI.toFloat() / 2 + 2 * Math.PI.toFloat() * i / 60
                val pos = AngleMath.positionOnCircle(center.x, center.y, outerRadius - 15, angle)
                drawCircle(color = Color.White, radius = 5f, center = pos)
            }
        }

        // Minutes ring rotation
        val minutesAngle = AngleMath.minutesAngle(currentElapsed)
        rotate(minutesAngle * 180 / Math.PI.toFloat(), center) {
            // Draw minutes numerals
            for (i in 0 until 60) {
                val angle = -Math.PI.toFloat() / 2 + 2 * Math.PI.toFloat() * i / 60
                val pos = AngleMath.positionOnCircle(center.x, center.y, innerRadius - 10, angle)
                drawCircle(color = Color.White, radius = 4f, center = pos)
            }
        }

        // Selector windows (fixed)
        val leftWindowX = center.x - outerRadius * 0.8f
        val rightWindowX = center.x + innerRadius * 0.8f
        val windowY = center.y
        val windowWidth = 40f
        val windowHeight = 20f

        drawRoundRect(
            Color.White,
            topLeft = Offset(leftWindowX - windowWidth / 2, windowY - windowHeight / 2),
            size = androidx.compose.ui.geometry.Size(windowWidth, windowHeight),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(10f)
        )

        drawRoundRect(
            Color.White,
            topLeft = Offset(rightWindowX - windowWidth / 2, windowY - windowHeight / 2),
            size = androidx.compose.ui.geometry.Size(windowWidth, windowHeight),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(10f)
        )

        // Center minutes
        val minutesRemaining = maxOf(0, (25 * 60 - currentElapsed.toInt()) / 60)
        // Draw text, but skip for now

        // Seconds badge
        val secondsRemaining = maxOf(0, (25 * 60 - currentElapsed.toInt()) % 60)
        drawOval(
            accentColor,
            topLeft = Offset(center.x - 15, center.y + 30),
            size = androidx.compose.ui.geometry.Size(30f, 15f)
        )
    }
}