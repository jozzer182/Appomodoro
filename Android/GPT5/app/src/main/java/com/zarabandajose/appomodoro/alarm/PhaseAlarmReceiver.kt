package com.zarabandajose.appomodoro.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.util.NotificationHelper
import com.zarabandajose.appomodoro.util.VibrationHelper

class PhaseAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val phaseName = intent?.getStringExtra(EXTRA_PHASE)
        val accent = intent?.getIntExtra(EXTRA_ACCENT_COLOR, DEFAULT_ACCENT) ?: DEFAULT_ACCENT
        val phase = PomodoroPhase.fromName(phaseName)
        NotificationHelper.createNotificationChannel(context)
        NotificationHelper.showPhaseComplete(context, phase, accent)
        VibrationHelper.vibrate(context)
    }

    companion object {
        const val EXTRA_PHASE = "extra_phase"
        const val EXTRA_ACCENT_COLOR = "extra_accent"
        private const val DEFAULT_ACCENT = 0xFF7C4DFF.toInt()
    }
}
