package com.example.appomodoro.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.withFrameNanos
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.TextMeasurer
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.appomodoro.model.PomodoroTimerState
import com.example.appomodoro.util.AngleMath
import kotlin.math.cos
import kotlin.math.sin

@OptIn(ExperimentalTextApi::class)
@Composable
fun DialCanvas(
    timerState: PomodoroTimerState,
    accentColor: Color
) {
    val textMeasurer = rememberTextMeasurer()
    var elapsedSec by remember { mutableStateOf(0.0) }

    LaunchedEffect(timerState.isRunning) {
        if (timerState.isRunning) {
            val startTime = System.nanoTime()
            val initialElapsed = (timerState.totalTime - timerState.remainingTime) / 1000.0
            while (true) {
                withFrameNanos { frameTime ->
                    elapsedSec = initialElapsed + (frameTime - startTime) / 1_000_000_000.0
                }
            }
        } else {
            elapsedSec = (timerState.totalTime - timerState.remainingTime) / 1000.0
        }
    }

    Canvas(modifier = Modifier.size(300.dp)) {
        val center = this.center
        val radius = size.minDimension / 2

        // Draw background
        drawCircle(color = Color(0xFF111214), radius = radius)

        // Draw ticks
        drawTicks(center, radius)

        // Draw seconds ring
        val thetaS = AngleMath.secondsToAngle(elapsedSec)
        rotate(degrees = thetaS, pivot = center) {
            drawSecondsRing(center, radius * 0.9f, textMeasurer)
        }

        // Draw minutes ring
        val thetaM = AngleMath.minutesToAngle(elapsedSec)
        rotate(degrees = thetaM, pivot = center) {
            drawMinutesRing(center, radius * 0.6f, textMeasurer)
        }

        // Draw center readout
        drawCenterReadout(timerState, center, textMeasurer, accentColor)

        // Draw selector windows
        drawSelectorWindows(center, radius, accentColor)
    }
}

private fun DrawScope.drawTicks(center: Offset, radius: Float) {
    for (i in 0 until 60) {
        val angle = i * 6f
        val startRadius = if (i % 5 == 0) radius * 0.95f else radius * 0.98f
        val endRadius = radius
        val start = Offset(
            center.x + startRadius * cos(Math.toRadians(angle.toDouble() - 90)).toFloat(),
            center.y + startRadius * sin(Math.toRadians(angle.toDouble() - 90)).toFloat()
        )
        val end = Offset(
            center.x + endRadius * cos(Math.toRadians(angle.toDouble() - 90)).toFloat(),
            center.y + endRadius * sin(Math.toRadians(angle.toDouble() - 90)).toFloat()
        )
        drawLine(Color.White, start, end, strokeWidth = 2f)
    }
}

@OptIn(ExperimentalTextApi::class)
private fun DrawScope.drawSecondsRing(center: Offset, radius: Float, textMeasurer: TextMeasurer) {
    for (i in 0 until 60) {
        val angle = i * 6.0
        val text = String.format("%02d", i)
        val textLayoutResult = textMeasurer.measure(text, style = TextStyle(fontSize = 16.sp, color = Color.White))
        val textWidth = textLayoutResult.size.width
        val textHeight = textLayoutResult.size.height
        val x = center.x + radius * cos(Math.toRadians(angle - 90)).toFloat() - textWidth / 2
        val y = center.y + radius * sin(Math.toRadians(angle - 90)).toFloat() - textHeight / 2
        drawText(textLayoutResult, topLeft = Offset(x, y))
    }
}

@OptIn(ExperimentalTextApi::class)
private fun DrawScope.drawMinutesRing(center: Offset, radius: Float, textMeasurer: TextMeasurer) {
    for (i in 0 until 60) {
        val angle = i * 6.0
        val text = String.format("%02d", i)
        val textLayoutResult = textMeasurer.measure(text, style = TextStyle(fontSize = 20.sp, color = Color.White))
        val textWidth = textLayoutResult.size.width
        val textHeight = textLayoutResult.size.height
        val x = center.x + radius * cos(Math.toRadians(angle - 90)).toFloat() - textWidth / 2
        val y = center.y + radius * sin(Math.toRadians(angle - 90)).toFloat() - textHeight / 2
        drawText(textLayoutResult, topLeft = Offset(x, y))
    }
}

@OptIn(ExperimentalTextApi::class)
private fun DrawScope.drawCenterReadout(
    timerState: PomodoroTimerState,
    center: Offset,
    textMeasurer: TextMeasurer,
    accentColor: Color
) {
    val minutes = (timerState.remainingTime / 1000 / 60).toInt()
    val seconds = (timerState.remainingTime / 1000 % 60).toInt()

    val minutesText = String.format("%02d", minutes)
    val minutesLayoutResult = textMeasurer.measure(minutesText, style = TextStyle(fontSize = 80.sp, color = Color.White))
    val minutesWidth = minutesLayoutResult.size.width
    val minutesHeight = minutesLayoutResult.size.height
    drawText(
        minutesLayoutResult,
        topLeft = Offset(center.x - minutesWidth / 2, center.y - minutesHeight / 2)
    )

    val secondsText = String.format("%02d", seconds)
    val secondsLayoutResult = textMeasurer.measure(secondsText, style = TextStyle(fontSize = 24.sp, color = Color.White))
    val secondsWidth = secondsLayoutResult.size.width
    val secondsHeight = secondsLayoutResult.size.height

    drawOval(
        color = accentColor,
        topLeft = Offset(center.x - secondsWidth / 2 - 10.dp.toPx(), center.y + minutesHeight / 2),
        size = androidx.compose.ui.geometry.Size(secondsWidth + 20.dp.toPx(), secondsHeight + 10.dp.toPx())
    )

    drawText(
        secondsLayoutResult,
        topLeft = Offset(center.x - secondsWidth / 2, center.y + minutesHeight / 2 + 5.dp.toPx())
    )
}

private fun DrawScope.drawSelectorWindows(center: Offset, radius: Float, accentColor: Color) {
    // Left selector for seconds
    val secondsSelectorY = center.y
    val secondsSelectorX = center.x - radius * 0.9f
    drawCircle(color = accentColor, radius = 20.dp.toPx(), center = Offset(secondsSelectorX, secondsSelectorY), style = androidx.compose.ui.graphics.drawscope.Stroke(width = 4.dp.toPx()))


    // Right selector for minutes
    val minutesSelectorY = center.y
    val minutesSelectorX = center.x + radius * 0.6f
    drawCircle(color = accentColor, radius = 25.dp.toPx(), center = Offset(minutesSelectorX, minutesSelectorY), style = androidx.compose.ui.graphics.drawscope.Stroke(width = 4.dp.toPx()))
}
