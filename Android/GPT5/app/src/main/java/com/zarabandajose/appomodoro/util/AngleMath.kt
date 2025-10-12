package com.zarabandajose.appomodoro.util

import kotlin.math.PI

fun secondsToAngleRadians(elapsedSeconds: Double): Float {
    val fraction = (elapsedSeconds % 60.0) / 60.0
    return baseAngleForFraction(fraction)
}

fun minutesToAngleRadians(elapsedSeconds: Double): Float {
    val fraction = ((elapsedSeconds / 60.0) % 60.0) / 60.0
    return baseAngleForFraction(fraction)
}

private fun baseAngleForFraction(fraction: Double): Float {
    val wrapped = ((fraction % 1.0) + 1.0) % 1.0
    val radians = -PI / 2.0 + 2.0 * PI * wrapped
    return radians.toFloat()
}
