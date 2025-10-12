package com.zarabandajose.appomodoro.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
import com.zarabandajose.appomodoro.model.PomodoroPhase

class PomodoroAlarmScheduler(private val context: Context) {

    private val alarmManager: AlarmManager? = ContextCompat.getSystemService(context, AlarmManager::class.java)

    fun schedule(endAtEpochMillis: Long, phase: PomodoroPhase, accentColor: Int) {
        val manager = alarmManager ?: return
        val triggerAtMillis = endAtEpochMillis.coerceAtLeast(System.currentTimeMillis())
        val pendingIntent = buildPendingIntent(phase, accentColor)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && manager.canScheduleExactAlarms().not()) {
            return
        }
        manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
    }

    fun cancel() {
        val manager = alarmManager ?: return
        manager.cancel(buildPendingIntent(PomodoroPhase.Focus, 0))
    }

    fun canScheduleExactAlarms(): Boolean {
        val manager = alarmManager ?: return false
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) manager.canScheduleExactAlarms() else true
    }

    private fun buildPendingIntent(phase: PomodoroPhase, accentColor: Int): PendingIntent {
        val intent = Intent(context, PhaseAlarmReceiver::class.java).apply {
            putExtra(PhaseAlarmReceiver.EXTRA_PHASE, phase.name)
            putExtra(PhaseAlarmReceiver.EXTRA_ACCENT_COLOR, accentColor)
        }
        return PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    companion object {
        private const val REQUEST_CODE = 7865
    }
}
