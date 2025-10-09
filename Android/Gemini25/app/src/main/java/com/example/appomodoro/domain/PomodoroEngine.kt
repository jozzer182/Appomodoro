package com.example.appomodoro.domain

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.appomodoro.data.SettingsStore
import com.example.appomodoro.model.PomodoroPhase
import com.example.appomodoro.model.PomodoroSettings
import com.example.appomodoro.model.PomodoroTimerState
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class PomodoroEngine(private val context: Context) : ViewModel() {

    private val settingsStore = SettingsStore(context)
    private val _settings = MutableStateFlow(PomodoroSettings())
    val settings: StateFlow<PomodoroSettings> = _settings.asStateFlow()

    private val _timerState = MutableStateFlow(PomodoroTimerState())
    val timerState: StateFlow<PomodoroTimerState> = _timerState.asStateFlow()

    private var timerJob: Job? = null
    private var startTime: Long = 0
    private var pauseTime: Long = 0

    init {
        viewModelScope.launch {
            _settings.value = settingsStore.settingsFlow.first()
            resetTimer()
        }
    }

    fun startTimer() {
        if (_timerState.value.isRunning) return
        startTime = System.currentTimeMillis() - (_timerState.value.totalTime - _timerState.value.remainingTime)
        _timerState.value = _timerState.value.copy(isRunning = true)
        timerJob = viewModelScope.launch {
            while (_timerState.value.isRunning) {
                val elapsed = System.currentTimeMillis() - startTime
                val remaining = _timerState.value.totalTime - elapsed
                if (remaining <= 0) {
                    onPhaseFinished()
                } else {
                    _timerState.value = _timerState.value.copy(remainingTime = remaining)
                }
                delay(16) // for 60fps
            }
        }
        setAlarm()
    }

    fun pauseTimer() {
        if (!_timerState.value.isRunning) return
        timerJob?.cancel()
        pauseTime = System.currentTimeMillis()
        _timerState.value = _timerState.value.copy(isRunning = false)
        cancelAlarm()
    }

    fun resumeTimer() {
        if (_timerState.value.isRunning) return
        startTime += System.currentTimeMillis() - pauseTime
        _timerState.value = _timerState.value.copy(isRunning = true)
        startTimer()
    }

    fun resetTimer() {
        timerJob?.cancel()
        val phase = _timerState.value.phase
        val duration = getDurationForPhase(phase)
        _timerState.value = PomodoroTimerState(
            phase = phase,
            totalTime = duration,
            remainingTime = duration,
            isRunning = false,
            sessionCount = _timerState.value.sessionCount
        )
        cancelAlarm()
    }

    fun nextPhase() {
        timerJob?.cancel()
        val currentPhase = _timerState.value.phase
        val currentSessionCount = _timerState.value.sessionCount
        val nextPhase: PomodoroPhase
        var nextSessionCount = currentSessionCount

        if (currentPhase == PomodoroPhase.FOCUS) {
            nextSessionCount++
            nextPhase = if (nextSessionCount % _settings.value.longBreakInterval == 0) {
                PomodoroPhase.LONG_BREAK
            } else {
                PomodoroPhase.SHORT_BREAK
            }
        } else {
            nextPhase = PomodoroPhase.FOCUS
        }

        val duration = getDurationForPhase(nextPhase)
        _timerState.value = PomodoroTimerState(
            phase = nextPhase,
            totalTime = duration,
            remainingTime = duration,
            isRunning = false,
            sessionCount = nextSessionCount
        )

        if (_settings.value.autoAdvance) {
            startTimer()
        }
    }

    private fun onPhaseFinished() {
        // show notification
        // then call nextPhase()
        nextPhase()
    }

    private fun getDurationForPhase(phase: PomodoroPhase): Long {
        return when (phase) {
            PomodoroPhase.FOCUS -> _settings.value.focusDuration * 60 * 1000L
            PomodoroPhase.SHORT_BREAK -> _settings.value.shortBreakDuration * 60 * 1000L
            PomodoroPhase.LONG_BREAK -> _settings.value.longBreakDuration * 60 * 1000L
            PomodoroPhase.CUSTOM -> 0 // not implemented
        }
    }

    private fun setAlarm() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PomodoroReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        val triggerAtMillis = System.currentTimeMillis() + _timerState.value.remainingTime
        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
    }

    private fun cancelAlarm() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PomodoroReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        alarmManager.cancel(pendingIntent)
    }

    fun updateSettings(newSettings: PomodoroSettings) {
        viewModelScope.launch {
            settingsStore.saveSettings(newSettings)
            _settings.value = newSettings
            resetTimer()
        }
    }
}

class PomodoroReceiver : android.content.BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // This is where you would show a notification
    }
}
