package com.zarabandajose.appomodoro.util

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.ui.MainActivity

object NotificationHelper {

    const val CHANNEL_ID = "pomodoro_phases"
    const val NOTIFICATION_ID = 1001

    fun createNotificationChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channelName = context.getString(R.string.notification_channel_name)
        val channelDescription = context.getString(R.string.notification_channel_description)
        val channel = NotificationChannel(
            CHANNEL_ID,
            channelName,
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = channelDescription
            enableVibration(true)
        }
        val manager = ContextCompat.getSystemService(context, NotificationManager::class.java)
        manager?.createNotificationChannel(channel)
    }

    fun showPhaseComplete(context: Context, phase: PomodoroPhase, accentColor: Int) {
        val title = context.getString(R.string.notification_title, context.getString(phase.labelRes))
        val content = context.getString(R.string.notification_body)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setContentTitle(title)
            .setContentText(content)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .setColor(accentColor)
            .setColorized(true)
            .build()

        NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
    }
}
