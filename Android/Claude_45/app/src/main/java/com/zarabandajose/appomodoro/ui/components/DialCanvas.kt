package com.zarabandajose.appomodoro.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.produceState
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.sp
import com.zarabandajose.appomodoro.util.AngleMath
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.sin

@Composable
fun DialCanvas(
    elapsedSeconds: Double,
    remainingMinutes: Int,
    remainingSeconds: Int,
    accentColor: Color,
    modifier: Modifier = Modifier
) {
    // 60 FPS frame updates
    val frameTime by produceState(0L) {
        while (isActive) {
            value = System.nanoTime()
            delay(16L) // ~60 FPS (16.67ms per frame)
        }
    }
    
    val textMeasurer = rememberTextMeasurer()
    
    Canvas(modifier = modifier.fillMaxSize()) {
        val centerX = size.width / 2f
        val centerY = size.height / 2f
        val maxRadius = minOf(centerX, centerY) * 0.85f
        
        // Calculate ring radii
        val outerRingRadius = maxRadius
        val innerRingRadius = maxRadius * 0.65f
        
        // Calculate angles from elapsed time
        val secondsAngle = AngleMath.calculateSecondsAngle(elapsedSeconds)
        val minutesAngle = AngleMath.calculateMinutesAngle(elapsedSeconds)
        
        // Draw background circle
        drawCircle(
            color = Color(0xFF111214),
            radius = maxRadius,
            center = Offset(centerX, centerY)
        )
        
        // Draw outer ticks (60 ticks for seconds)
        drawTicks(
            centerX = centerX,
            centerY = centerY,
            radius = outerRingRadius,
            count = 60,
            tickColor = Color(0xFF3A3D42),
            majorTickInterval = 5,
            majorTickColor = Color(0xFF5F6368),
            strokeWidth = 2f,
            tickLength = 12f,
            majorTickLength = 20f
        )
        
        // Draw inner ticks (60 ticks for minutes)
        drawTicks(
            centerX = centerX,
            centerY = centerY,
            radius = innerRingRadius,
            count = 60,
            tickColor = Color(0xFF2A2D31),
            majorTickInterval = 5,
            majorTickColor = Color(0xFF4A4D52),
            strokeWidth = 1.5f,
            tickLength = 8f,
            majorTickLength = 14f
        )
        
        // Draw rotating seconds ring with numbers
        rotate(degrees = Math.toDegrees(secondsAngle.toDouble()).toFloat(), pivot = Offset(centerX, centerY)) {
            drawNumberRing(
                centerX = centerX,
                centerY = centerY,
                radius = outerRingRadius - 35f,
                count = 60,
                textColor = Color(0xFF9AA0A6),
                textSize = 12.sp,
                textMeasurer = textMeasurer,
                showAll = false, // Only show every 5th
                interval = 5
            )
        }
        
        // Draw rotating minutes ring with numbers
        rotate(degrees = Math.toDegrees(minutesAngle.toDouble()).toFloat(), pivot = Offset(centerX, centerY)) {
            drawNumberRing(
                centerX = centerX,
                centerY = centerY,
                radius = innerRingRadius - 25f,
                count = 60,
                textColor = Color(0xFF7A7D82),
                textSize = 10.sp,
                textMeasurer = textMeasurer,
                showAll = false,
                interval = 5
            )
        }
        
        // Draw selector windows (fixed - don't rotate)
        // LEFT window for seconds
        drawSelectorWindow(
            centerX = centerX - outerRingRadius + 50f,
            centerY = centerY,
            width = 50f,
            height = 35f,
            color = accentColor.copy(alpha = 0.3f),
            strokeColor = accentColor
        )
        
        // RIGHT window for minutes
        drawSelectorWindow(
            centerX = centerX + innerRingRadius - 35f,
            centerY = centerY,
            width = 45f,
            height = 32f,
            color = accentColor.copy(alpha = 0.2f),
            strokeColor = accentColor.copy(alpha = 0.7f)
        )
        
        // Draw center readout
        // Large minutes number
        val minutesText = String.format("%02d", remainingMinutes)
        val minutesStyle = TextStyle(
            fontSize = 56.sp,
            color = Color(0xFFE8EAED)
        )
        val minutesLayout = textMeasurer.measure(minutesText, minutesStyle)
        drawText(
            textLayoutResult = minutesLayout,
            topLeft = Offset(
                centerX - minutesLayout.size.width / 2f - 25f,
                centerY - minutesLayout.size.height / 2f
            )
        )
        
        // Small seconds oval badge
        val secondsText = String.format("%02d", remainingSeconds)
        val badgeX = centerX + 35f
        val badgeY = centerY
        
        // Draw oval badge background
        drawOval(
            color = accentColor,
            topLeft = Offset(badgeX - 22f, badgeY - 18f),
            size = androidx.compose.ui.geometry.Size(44f, 36f)
        )
        
        // Draw seconds text on badge
        val secondsStyle = TextStyle(
            fontSize = 18.sp,
            color = Color.White
        )
        val secondsLayout = textMeasurer.measure(secondsText, secondsStyle)
        drawText(
            textLayoutResult = secondsLayout,
            topLeft = Offset(
                badgeX - secondsLayout.size.width / 2f,
                badgeY - secondsLayout.size.height / 2f
            )
        )
    }
}

private fun DrawScope.drawTicks(
    centerX: Float,
    centerY: Float,
    radius: Float,
    count: Int,
    tickColor: Color,
    majorTickInterval: Int,
    majorTickColor: Color,
    strokeWidth: Float,
    tickLength: Float,
    majorTickLength: Float
) {
    for (i in 0 until count) {
        val angle = -PI.toFloat() / 2f + (2f * PI.toFloat() * i / count)
        val isMajor = i % majorTickInterval == 0
        val length = if (isMajor) majorTickLength else tickLength
        val color = if (isMajor) majorTickColor else tickColor
        val width = if (isMajor) strokeWidth * 1.5f else strokeWidth
        
        val startX = centerX + (radius - length) * cos(angle)
        val startY = centerY + (radius - length) * sin(angle)
        val endX = centerX + radius * cos(angle)
        val endY = centerY + radius * sin(angle)
        
        drawLine(
            color = color,
            start = Offset(startX, startY),
            end = Offset(endX, endY),
            strokeWidth = width,
            cap = StrokeCap.Round
        )
    }
}

private fun DrawScope.drawNumberRing(
    centerX: Float,
    centerY: Float,
    radius: Float,
    count: Int,
    textColor: Color,
    textSize: androidx.compose.ui.unit.TextUnit,
    textMeasurer: androidx.compose.ui.text.TextMeasurer,
    showAll: Boolean,
    interval: Int
) {
    for (i in 0 until count) {
        if (!showAll && i % interval != 0) continue
        
        // Position number upright (counter-rotate)
        val angle = -PI.toFloat() / 2f + (2f * PI.toFloat() * i / count)
        val x = centerX + radius * cos(angle)
        val y = centerY + radius * sin(angle)
        
        val number = i.toString()
        val textStyle = TextStyle(fontSize = textSize, color = textColor)
        val textLayout = textMeasurer.measure(number, textStyle)
        
        // Counter-rotate the text so it appears upright
        rotate(degrees = -Math.toDegrees(angle.toDouble()).toFloat() + 90f, pivot = Offset(x, y)) {
            drawText(
                textLayoutResult = textLayout,
                topLeft = Offset(
                    x - textLayout.size.width / 2f,
                    y - textLayout.size.height / 2f
                )
            )
        }
    }
}

private fun DrawScope.drawSelectorWindow(
    centerX: Float,
    centerY: Float,
    width: Float,
    height: Float,
    color: Color,
    strokeColor: Color
) {
    // Draw rounded rectangle for selector window
    drawRoundRect(
        color = color,
        topLeft = Offset(centerX - width / 2f, centerY - height / 2f),
        size = androidx.compose.ui.geometry.Size(width, height),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(8f, 8f)
    )
    
    drawRoundRect(
        color = strokeColor,
        topLeft = Offset(centerX - width / 2f, centerY - height / 2f),
        size = androidx.compose.ui.geometry.Size(width, height),
        cornerRadius = androidx.compose.ui.geometry.CornerRadius(8f, 8f),
        style = Stroke(width = 2f)
    )
}
