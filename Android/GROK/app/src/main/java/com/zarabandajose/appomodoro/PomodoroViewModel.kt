package com.zarabandajose.appomodoro

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.core.app.NotificationCompat
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.zarabandajose.appomodoro.data.SettingsStore
import com.zarabandajose.appomodoro.domain.PomodoroEngine
import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class PomodoroViewModel(
    private val context: Context,
    private val settingsStore: SettingsStore
) : ViewModel() {

    private val engine = PomodoroEngine(PomodoroSettings())

    private val _settings = MutableStateFlow(PomodoroSettings())
    val settings: StateFlow<PomodoroSettings> = _settings

    private val _state = MutableStateFlow(PomodoroTimerState())
    val state: StateFlow<PomodoroTimerState> = _state

    private val _elapsedSec = MutableStateFlow(0.0)
    val elapsedSec: StateFlow<Double> = _elapsedSec

    init {
        viewModelScope.launch {
            settingsStore.settingsFlow.collect { settings ->
                _settings.value = settings
            }
        }
        createNotificationChannel()
    }

    fun start() {
        val currentState = _state.value
        if (!currentState.isRunning) {
            val newState = currentState.copy(
                isRunning = true,
                isPaused = false,
                startTime = System.currentTimeMillis(),
                pausedTime = 0L
            )
            _state.value = newState
            scheduleAlarm(newState.totalSeconds * 1000L)
        }
    }

    fun pause() {
        val currentState = _state.value
        if (currentState.isRunning && !currentState.isPaused) {
            val pausedTime = System.currentTimeMillis() - currentState.startTime
            _state.value = currentState.copy(isPaused = true, pausedTime = pausedTime)
        }
    }

    fun resume() {
        val currentState = _state.value
        if (currentState.isRunning && currentState.isPaused) {
            val newStartTime = System.currentTimeMillis() - currentState.pausedTime
            _state.value = currentState.copy(isPaused = false, startTime = newStartTime, pausedTime = 0L)
        }
    }

    fun reset() {
        _state.value = PomodoroTimerState()
        _elapsedSec.value = 0.0
        cancelAlarm()
    }

    fun nextPhase() {
        val currentState = _state.value
        val nextPhase = engine.getNextPhase(currentState.currentPhase, currentState.cycleCount)
        val duration = engine.getDurationForPhase(nextPhase)
        val newCycleCount = if (nextPhase == PomodoroPhase.Focus) currentState.cycleCount + 1 else currentState.cycleCount
        _state.value = PomodoroTimerState(
            currentPhase = nextPhase,
            totalSeconds = duration,
            remainingSeconds = duration,
            cycleCount = newCycleCount
        )
        _elapsedSec.value = 0.0
    }

    fun updateElapsed(currentTime: Long) {
        val currentState = _state.value
        if (currentState.isRunning && !currentState.isPaused) {
            val elapsed = engine.calculateElapsedSeconds(currentState, currentTime)
            _elapsedSec.value = elapsed
            val remaining = engine.calculateRemainingSeconds(currentState, elapsed)
            _state.value = currentState.copy(remainingSeconds = remaining)
            if (engine.isPhaseEnded(currentState, elapsed)) {
                onPhaseEnd()
            }
        }
    }

    private fun onPhaseEnd() {
        vibrate()
        showNotification()
        if (_settings.value.autoAdvance) {
            nextPhase()
        }
    }

    private fun vibrate() {
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            vibrator.vibrate(500)
        }
    }

    private fun showNotification() {
        if (!_settings.value.notificationsEnabled) return
        val notification = NotificationCompat.Builder(context, "pomodoro_channel")
            .setContentTitle("Pomodoro")
            .setContentText("Phase ended")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(1, notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "pomodoro_channel",
                "Pomodoro Notifications",
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Notifications for Pomodoro timer phases"
            }
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    private fun scheduleAlarm(delayMillis: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PomodoroAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + delayMillis, pendingIntent)
    }

    private fun cancelAlarm() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PomodoroAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        alarmManager.cancel(pendingIntent)
    }

    fun saveSettings(newSettings: PomodoroSettings) {
        viewModelScope.launch {
            settingsStore.saveSettings(newSettings)
        }
    }
}