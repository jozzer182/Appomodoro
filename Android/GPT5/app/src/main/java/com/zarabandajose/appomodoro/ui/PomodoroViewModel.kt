package com.zarabandajose.appomodoro.ui

import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.zarabandajose.appomodoro.alarm.PomodoroAlarmScheduler
import com.zarabandajose.appomodoro.data.SettingsStore
import com.zarabandajose.appomodoro.domain.PomodoroEngine
import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import com.zarabandajose.appomodoro.util.NotificationHelper
import com.zarabandajose.appomodoro.util.VibrationHelper
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

class PomodoroViewModel(
    private val applicationContext: Context,
    private val settingsStore: SettingsStore,
    private val engine: PomodoroEngine,
    private val alarmScheduler: PomodoroAlarmScheduler
) : ViewModel() {

    private val _settings = MutableStateFlow(PomodoroSettings.Default)
    val settings = _settings.asStateFlow()

    private val _timerState = MutableStateFlow(PomodoroTimerState.initial(PomodoroSettings.Default))
    val timerState = _timerState.asStateFlow()

    private val _events = MutableSharedFlow<PomodoroEvent>(replay = 0, extraBufferCapacity = 1)
    val events = _events.asSharedFlow()

    init {
        viewModelScope.launch {
            settingsStore.settingsFlow.collect { newSettings ->
                _settings.value = newSettings
                val snapshot = engine.onSettingsChanged(newSettings)
                updateTimerState(snapshot)
                rescheduleFromState(snapshot, newSettings)
            }
        }

        viewModelScope.launch {
            while (isActive) {
                val now = System.currentTimeMillis()
                val outcome = engine.onTick(_settings.value, now)
                updateTimerState(outcome.state)
                val completed = outcome.completedPhase
                if (completed != null) {
                    handlePhaseCompletion(completed, now)
                }
                delay(TICK_INTERVAL_MS)
            }
        }
    }

    fun startOrResume() {
        val currentSettings = _settings.value
        val now = System.currentTimeMillis()
        val snapshot = engine.startOrResume(currentSettings, now)
        updateTimerState(snapshot)
        rescheduleFromState(snapshot, currentSettings)
    }

    fun pause() {
        val currentSettings = _settings.value
        val now = System.currentTimeMillis()
        val snapshot = engine.pause(currentSettings, now)
        updateTimerState(snapshot)
        alarmScheduler.cancel()
    }

    fun reset() {
        val currentSettings = _settings.value
        val now = System.currentTimeMillis()
        val snapshot = engine.reset(currentSettings, now)
        updateTimerState(snapshot)
        alarmScheduler.cancel()
    }

    fun skipPhase() {
        val currentSettings = _settings.value
        val now = System.currentTimeMillis()
        val startImmediately = _timerState.value.isRunning
        val snapshot = engine.skipToNextPhase(currentSettings, now, startImmediately)
        updateTimerState(snapshot)
        rescheduleFromState(snapshot, currentSettings)
    }

    fun selectPhase(phase: PomodoroPhase) {
        val currentSettings = _settings.value
        val now = System.currentTimeMillis()
        val snapshot = engine.selectPhase(phase, currentSettings, now)
        updateTimerState(snapshot)
        alarmScheduler.cancel()
    }

    fun updateDurations(focus: Int, shortBreak: Int, longBreak: Int, custom: Int) {
        viewModelScope.launch {
            settingsStore.updateDurations(focus, shortBreak, longBreak, custom)
        }
    }

    fun updateAccent(color: Int) {
        viewModelScope.launch {
            settingsStore.updateAccentColor(color)
        }
    }

    fun updateAutoAdvance(enabled: Boolean) {
        viewModelScope.launch {
            settingsStore.updateAutoAdvance(enabled)
        }
    }

    fun updateNotifications(enabled: Boolean) {
        viewModelScope.launch {
            settingsStore.updateNotificationsEnabled(enabled)
            if (!enabled) {
                alarmScheduler.cancel()
            } else {
                rescheduleFromState(_timerState.value, _settings.value.copy(notificationsEnabled = true))
            }
        }
    }

    private fun updateTimerState(newState: PomodoroTimerState) {
        if (_timerState.value != newState) {
            _timerState.value = newState
        }
    }

    private fun rescheduleFromState(state: PomodoroTimerState, settings: PomodoroSettings) {
        if (!settings.notificationsEnabled) {
            alarmScheduler.cancel()
            return
        }
        if (state.isRunning) {
            val endAt = state.expectedEndEpochMillis()
            if (endAt != null) {
                alarmScheduler.schedule(endAt, state.phase, settings.accentColor)
            }
        } else {
            alarmScheduler.cancel()
        }
    }

    private fun handlePhaseCompletion(completed: PomodoroPhase, now: Long) {
        val currentSettings = _settings.value
        if (currentSettings.notificationsEnabled) {
            NotificationHelper.showPhaseComplete(applicationContext, completed, currentSettings.accentColor)
            VibrationHelper.vibrate(applicationContext)
        }
        val updatedState = engine.handleCompletion(currentSettings, currentSettings.autoAdvance, now)
        updateTimerState(updatedState)
        rescheduleFromState(updatedState, currentSettings)
        _events.tryEmit(
            PomodoroEvent.PhaseCompleted(
                completedPhase = completed,
                upcomingPhase = updatedState.phase
            )
        )
    }

    sealed interface PomodoroEvent {
        data class PhaseCompleted(val completedPhase: PomodoroPhase, val upcomingPhase: PomodoroPhase) : PomodoroEvent
    }

    companion object {
        private const val TICK_INTERVAL_MS = 200L

        fun factory(context: Context): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val appContext = context.applicationContext
                val settingsStore = SettingsStore(appContext)
                val engine = PomodoroEngine()
                val scheduler = PomodoroAlarmScheduler(appContext)
                @Suppress("UNCHECKED_CAST")
                return PomodoroViewModel(appContext, settingsStore, engine, scheduler) as T
            }
        }
    }
}
