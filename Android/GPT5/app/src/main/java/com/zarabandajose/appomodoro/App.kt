package com.zarabandajose.appomodoro

import android.app.Application
import com.zarabandajose.appomodoro.util.NotificationHelper

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        NotificationHelper.createNotificationChannel(this)
    }
}
