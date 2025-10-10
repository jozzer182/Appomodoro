package com.zarabandajose.appomodoro

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class PomodoroAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Handle alarm, but since ViewModel is not accessible, perhaps use a service or something.
        // For simplicity, ignore for now.
    }
}