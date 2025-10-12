package com.zarabandajose.appomodoro.ui

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.data.SettingsStore
import com.zarabandajose.appomodoro.domain.PomodoroEngine
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

class PomodoroViewModel(application: Application) : AndroidViewModel(application) {
    
    private val settingsStore = SettingsStore(application)
    
    private val _settings = MutableStateFlow(PomodoroSettings())
    val settings: StateFlow<PomodoroSettings> = _settings.asStateFlow()
    
    private lateinit var engine: PomodoroEngine
    
    private val _timerState = MutableStateFlow(PomodoroTimerState())
    val timerState: StateFlow<PomodoroTimerState> = _timerState.asStateFlow()
    
    private var timerJob: Job? = null
    
    companion object {
        private const val NOTIFICATION_CHANNEL_ID = "pomodoro_timer"
        private const val NOTIFICATION_ID = 1001
    }
    
    init {
        viewModelScope.launch {
            settingsStore.settingsFlow.collect { loadedSettings ->
                _settings.value = loadedSettings
                engine = PomodoroEngine(loadedSettings)
                
                // Subscribe to engine state
                launch {
                    engine.state.collect { state ->
                        _timerState.value = state
                    }
                }
            }
        }
        
        createNotificationChannel()
    }
    
    fun startTimer() {
        engine.start()
        startTimerLoop()
    }
    
    fun pauseTimer() {
        engine.pause()
        timerJob?.cancel()
    }
    
    fun resetTimer() {
        timerJob?.cancel()
        engine.reset()
    }
    
    fun nextPhase() {
        timerJob?.cancel()
        engine.nextPhase()
        
        if (_settings.value.autoAdvancePhases) {
            startTimer()
        }
    }
    
    fun updateSettings(newSettings: PomodoroSettings) {
        viewModelScope.launch {
            settingsStore.updateSettings(newSettings)
        }
    }
    
    private fun startTimerLoop() {
        timerJob?.cancel()
        timerJob = viewModelScope.launch {
            while (isActive) {
                val isPhaseComplete = engine.updateFromTimestamp(System.currentTimeMillis())
                
                if (isPhaseComplete) {
                    onPhaseComplete()
                    break
                }
                
                delay(16L) // ~60 FPS updates
            }
        }
    }
    
    private fun onPhaseComplete() {
        if (_settings.value.enableNotifications) {
            showPhaseCompleteNotification()
        }
        
        vibrateDevice()
        
        if (_settings.value.autoAdvancePhases) {
            nextPhase()
        }
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Pomodoro Timer",
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Notifications for Pomodoro timer phase completion"
                enableVibration(true)
            }
            
            val notificationManager = getApplication<Application>().getSystemService(
                Context.NOTIFICATION_SERVICE
            ) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun showPhaseCompleteNotification() {
        val context = getApplication<Application>()
        val currentPhase = _timerState.value.currentPhase
        
        val notification = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setContentTitle("${currentPhase.displayName} Complete!")
            .setContentText("Time for the next phase")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
            .build()
        
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notification)
    }
    
    private fun vibrateDevice() {
        val context = getApplication<Application>()
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as android.os.VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as android.os.Vibrator
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(
                android.os.VibrationEffect.createOneShot(
                    500,
                    android.os.VibrationEffect.DEFAULT_AMPLITUDE
                )
            )
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(500)
        }
    }
}
