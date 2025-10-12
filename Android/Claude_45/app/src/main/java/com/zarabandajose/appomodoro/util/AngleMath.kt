package com.zarabandajose.appomodoro.util

import kotlin.math.PI

object AngleMath {
    /**
     * Calculate the angle for the seconds ring rotation.
     * Formula: θ = -π/2 + 2π * ((elapsedSec % 60) / 60)
     * 
     * @param elapsedSeconds Total elapsed seconds (can be > 60)
     * @return Angle in radians for seconds ring rotation
     */
    fun calculateSecondsAngle(elapsedSeconds: Double): Float {
        val normalizedSeconds = elapsedSeconds % 60.0
        return (-PI / 2.0 + 2.0 * PI * (normalizedSeconds / 60.0)).toFloat()
    }
    
    /**
     * Calculate the angle for the minutes ring rotation.
     * Formula: θ = -π/2 + 2π * ((elapsedSec / 60) / 60)
     * This creates a smooth minutes rotation (1 full turn per 3600 seconds = 1 hour)
     * 
     * @param elapsedSeconds Total elapsed seconds
     * @return Angle in radians for minutes ring rotation
     */
    fun calculateMinutesAngle(elapsedSeconds: Double): Float {
        val minutesFraction = (elapsedSeconds / 60.0) / 60.0
        return (-PI / 2.0 + 2.0 * PI * minutesFraction).toFloat()
    }
    
    /**
     * Calculate position on a circle given angle and radius.
     * Returns x offset from center.
     */
    fun getXOnCircle(angle: Float, radius: Float): Float {
        return radius * kotlin.math.cos(angle)
    }
    
    /**
     * Calculate position on a circle given angle and radius.
     * Returns y offset from center.
     */
    fun getYOnCircle(angle: Float, radius: Float): Float {
        return radius * kotlin.math.sin(angle)
    }
}
