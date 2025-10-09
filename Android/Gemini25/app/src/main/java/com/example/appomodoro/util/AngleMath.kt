package com.example.appomodoro.util

object AngleMath {
    fun secondsToAngle(elapsedSec: Double): Float {
        return (-90 + 360 * ((elapsedSec % 60.0) / 60.0)).toFloat()
    }

    fun minutesToAngle(elapsedSec: Double): Float {
        return (-90 + 360 * ((elapsedSec / 60.0) / 60.0)).toFloat()
    }
}
