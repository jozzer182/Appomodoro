package com.zarabandajose.appomodoro.util

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.content.ContextCompat

object VibrationHelper {

    fun vibrate(context: Context) {
        val amplitude = VibrationEffect.DEFAULT_AMPLITUDE
        val duration = 120L
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val manager = ContextCompat.getSystemService(context, VibratorManager::class.java)
            manager?.defaultVibrator?.vibrate(VibrationEffect.createOneShot(duration, amplitude))
        } else {
            @Suppress("DEPRECATION")
            val vibrator = ContextCompat.getSystemService(context, Vibrator::class.java)
            @Suppress("DEPRECATION")
            vibrator?.vibrate(VibrationEffect.createOneShot(duration, amplitude))
        }
    }
}
