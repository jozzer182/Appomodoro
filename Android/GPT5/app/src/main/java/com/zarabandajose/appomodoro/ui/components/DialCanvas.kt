package com.zarabandajose.appomodoro.ui.components

import android.graphics.Paint
import android.graphics.Typeface
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.withFrameNanos
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import com.zarabandajose.appomodoro.util.minutesToAngleRadians
import com.zarabandajose.appomodoro.util.secondsToAngleRadians
import kotlinx.coroutines.isActive
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.min
import kotlin.math.sin

@Composable
fun DialCanvas(
    timerState: PomodoroTimerState,
    accentColor: Color,
    modifier: Modifier = Modifier
) {
    val animatedElapsed = remember { mutableStateOf(timerState.elapsedMillisSnapshot.toDouble()) }

    LaunchedEffect(
        timerState.phaseStartEpochMillis,
        timerState.accumulatedPauseMillis,
        timerState.pausedAtEpochMillis,
        timerState.isRunning,
        timerState.phaseDurationMillis
    ) {
        animatedElapsed.value = timerState.elapsedMillisSnapshot.toDouble()
        if (timerState.isRunning && timerState.phaseStartEpochMillis != null) {
            while (isActive) {
                withFrameNanos {
                    animatedElapsed.value = timerState.elapsedMillis(System.currentTimeMillis()).toDouble()
                }
            }
        }
    }

    val backgroundColor = MaterialTheme.colorScheme.surface
    val ringColor = MaterialTheme.colorScheme.surfaceVariant
    val tickColor = MaterialTheme.colorScheme.outline
    val tickHighlightColor = MaterialTheme.colorScheme.onSurface
    val textColor = MaterialTheme.colorScheme.onSurface
    val secondaryTextColor = MaterialTheme.colorScheme.onSurfaceVariant

    val drawElapsed = min(animatedElapsed.value, timerState.phaseDurationMillis.toDouble())
    val elapsedSeconds = drawElapsed / 1000.0
    val remainingMillis = max(0.0, timerState.phaseDurationMillis - drawElapsed)
    val minutesRemaining = floor(remainingMillis / 60_000.0).toInt()
    val secondsRemaining = floor((remainingMillis / 1000.0) % 60.0).toInt()
    val currentSecond = floor(elapsedSeconds % 60.0).toInt()
    val currentMinute = floor((elapsedSeconds / 60.0) % 60.0).toInt()

    BoxWithConstraints(
        modifier = modifier
            .fillMaxWidth()
            .aspectRatio(1f)
            .padding(16.dp)
    ) {
        val secondsTextPaint = rememberPaint(Typeface.MONOSPACE)
        val minutesTextPaint = rememberPaint(Typeface.MONOSPACE)
        val windowTextPaint = rememberPaint(Typeface.MONOSPACE)

        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(backgroundColor, RoundedCornerShape(28.dp))
        ) {
            Canvas(modifier = Modifier.fillMaxSize()) {
                val minDimension = size.minDimension
                val center = Offset(size.width / 2f, size.height / 2f)
                val outerRadius = minDimension * 0.48f
                val secondsRadius = minDimension * 0.42f
                val minutesRadius = minDimension * 0.30f
                val ringStroke = minDimension * 0.01f
                val secondsAngle = secondsToAngleRadians(elapsedSeconds)
                val minutesAngle = minutesToAngleRadians(elapsedSeconds)

                drawCircle(color = backgroundColor, radius = outerRadius, center = center)
                drawCircle(color = ringColor, radius = outerRadius, center = center, style = Stroke(width = ringStroke))

                drawRingTicks(
                    center = center,
                    radius = secondsRadius,
                    rotation = secondsAngle,
                    tickColor = tickColor,
                    highlightColor = tickHighlightColor,
                    outerLength = minDimension * 0.04f,
                    innerLength = minDimension * 0.018f,
                    strokeWide = minDimension * 0.005f,
                    strokeNarrow = minDimension * 0.003f
                )

                drawRingTicks(
                    center = center,
                    radius = minutesRadius,
                    rotation = minutesAngle,
                    tickColor = tickColor.copy(alpha = 0.6f),
                    highlightColor = tickHighlightColor.copy(alpha = 0.8f),
                    outerLength = minDimension * 0.028f,
                    innerLength = minDimension * 0.012f,
                    strokeWide = minDimension * 0.004f,
                    strokeNarrow = minDimension * 0.002f
                )

                secondsTextPaint.color = textColor.toArgb()
                secondsTextPaint.textSize = minDimension * 0.06f
                val secondsBaseline = (secondsTextPaint.descent() + secondsTextPaint.ascent()) / 2f

                minutesTextPaint.color = secondaryTextColor.toArgb()
                minutesTextPaint.textSize = minDimension * 0.05f
                val minutesBaseline = (minutesTextPaint.descent() + minutesTextPaint.ascent()) / 2f

                drawRotatingNumerals(
                    paint = secondsTextPaint,
                    center = center,
                    radius = secondsRadius - minDimension * 0.05f,
                    rotation = secondsAngle,
                    baselineOffset = secondsBaseline
                ) { index -> String.format("%02d", index) }

                drawRotatingNumerals(
                    paint = minutesTextPaint,
                    center = center,
                    radius = minutesRadius - minDimension * 0.04f,
                    rotation = minutesAngle,
                    baselineOffset = minutesBaseline
                ) { index -> String.format("%02d", index) }

                drawSelectorWindow(
                    center = center,
                    width = minDimension * 0.34f,
                    height = minDimension * 0.18f,
                    offsetFromCenter = secondsRadius * 0.65f,
                    onLeft = true,
                    background = ringColor,
                    border = accentColor,
                    label = String.format("%02d", currentSecond),
                    accent = accentColor,
                    textPaint = windowTextPaint
                )

                drawSelectorWindow(
                    center = center,
                    width = minDimension * 0.32f,
                    height = minDimension * 0.16f,
                    offsetFromCenter = minutesRadius * 0.65f,
                    onLeft = false,
                    background = ringColor,
                    border = accentColor,
                    label = String.format("%02d", currentMinute),
                    accent = accentColor,
                    textPaint = windowTextPaint
                )
            }

            CenterReadout(
                minutes = minutesRemaining,
                seconds = secondsRemaining,
                accent = accentColor,
                modifier = Modifier.align(Alignment.Center)
            )
        }
    }
}

@Composable
private fun rememberPaint(typeface: Typeface): Paint = remember {
    Paint(Paint.ANTI_ALIAS_FLAG).apply {
        textAlign = Paint.Align.CENTER
        isLinearText = true
        this.typeface = Typeface.create(typeface, Typeface.BOLD)
    }
}

private fun androidx.compose.ui.graphics.drawscope.DrawScope.drawRingTicks(
    center: Offset,
    radius: Float,
    rotation: Float,
    tickColor: Color,
    highlightColor: Color,
    outerLength: Float,
    innerLength: Float,
    strokeWide: Float,
    strokeNarrow: Float
) {
    for (index in 0 until 60) {
        val baseAngle = (2 * PI * index / 60.0).toFloat()
        val angle = baseAngle + rotation
        val cos = cos(angle)
        val sin = sin(angle)
        val outer = radius + outerLength
        val inner = outer - if (index % 5 == 0) outerLength else innerLength
        val stroke = if (index % 5 == 0) strokeWide else strokeNarrow
        val color = if (index % 5 == 0) highlightColor else tickColor
        drawLine(
            color = color,
            start = Offset(center.x + cos * inner, center.y + sin * inner),
            end = Offset(center.x + cos * outer, center.y + sin * outer),
            strokeWidth = stroke,
            cap = StrokeCap.Round
        )
    }
}

private fun androidx.compose.ui.graphics.drawscope.DrawScope.drawRotatingNumerals(
    paint: Paint,
    center: Offset,
    radius: Float,
    rotation: Float,
    baselineOffset: Float,
    labelProvider: (Int) -> String
) {
    val canvas = drawContext.canvas.nativeCanvas
    for (index in 0 until 60) {
        val baseAngle = (2 * PI * index / 60.0).toFloat()
        val angle = baseAngle + rotation
        val cos = cos(angle)
        val sin = sin(angle)
        val x = center.x + cos * radius
        val y = center.y + sin * radius
        canvas.save()
        canvas.translate(x, y)
        val degrees = Math.toDegrees(angle.toDouble()).toFloat()
        canvas.rotate(-degrees + 90f)
        canvas.drawText(labelProvider(index), 0f, -baselineOffset, paint)
        canvas.restore()
    }
}

private fun androidx.compose.ui.graphics.drawscope.DrawScope.drawSelectorWindow(
    center: Offset,
    width: Float,
    height: Float,
    offsetFromCenter: Float,
    onLeft: Boolean,
    background: Color,
    border: Color,
    label: String,
    accent: Color,
    textPaint: Paint
) {
    val corner = CornerRadius(height / 2f, height / 2f)
    val xOffset = if (onLeft) -offsetFromCenter - width / 2f else offsetFromCenter + width / 2f
    val origin = Offset(center.x + xOffset - width / 2f, center.y - height / 2f)
    val rectSize = Size(width, height)
    drawRoundRect(color = background.copy(alpha = 0.85f), topLeft = origin, size = rectSize, cornerRadius = corner)
    drawRoundRect(color = border, topLeft = origin, size = rectSize, cornerRadius = corner, style = Stroke(width = height * 0.08f))
    textPaint.color = accent.toArgb()
    textPaint.textAlign = Paint.Align.CENTER
    textPaint.textSize = height * 0.45f
    val baseline = (textPaint.descent() + textPaint.ascent()) / 2f
    val canvas = drawContext.canvas.nativeCanvas
    canvas.save()
    canvas.translate(center.x + xOffset, center.y)
    canvas.drawText(label, 0f, -baseline, textPaint)
    canvas.restore()
}

@Composable
private fun CenterReadout(
    minutes: Int,
    seconds: Int,
    accent: Color,
    modifier: Modifier = Modifier
) {
    Box(modifier = modifier) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = String.format("%02d", minutes),
                style = MaterialTheme.typography.displayLarge,
                color = MaterialTheme.colorScheme.onBackground
            )
            Surface(
                color = accent,
                contentColor = Color.White,
                shape = RoundedCornerShape(50),
                shadowElevation = 0.dp
            ) {
                Text(
                    text = String.format("%02d", seconds),
                    style = MaterialTheme.typography.titleSmall,
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp)
                )
            }
        }
    }
}
