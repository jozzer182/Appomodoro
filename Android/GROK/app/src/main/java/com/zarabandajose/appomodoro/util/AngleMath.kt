package com.zarabandajose.appomodoro.util

import androidx.compose.ui.geometry.Offset
import kotlin.math.*

object AngleMath {
    fun secondsAngle(elapsedSec: Double): Float {
        val fraction = (elapsedSec % 60.0) / 60.0
        return (-PI / 2 + 2 * PI * fraction).toFloat()
    }

    fun minutesAngle(elapsedSec: Double): Float {
        val fraction = (elapsedSec / 60.0) / 60.0
        return (-PI / 2 + 2 * PI * fraction).toFloat()
    }

    fun positionOnCircle(centerX: Float, centerY: Float, radius: Float, angle: Float): Offset {
        val x = centerX + radius * cos(angle)
        val y = centerY + radius * sin(angle)
        return Offset(x, y)
    }
}