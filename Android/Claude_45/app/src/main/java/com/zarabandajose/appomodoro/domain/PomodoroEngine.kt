package com.zarabandajose.appomodoro.domain

import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class PomodoroEngine(private val settings: PomodoroSettings) {
    
    private val _state = MutableStateFlow(createInitialState())
    val state: StateFlow<PomodoroTimerState> = _state.asStateFlow()
    
    private fun createInitialState(): PomodoroTimerState {
        val durationSeconds = (settings.focusDurationMinutes * 60).toDouble()
        return PomodoroTimerState(
            currentPhase = PomodoroPhase.FOCUS,
            remainingSeconds = durationSeconds,
            totalSeconds = durationSeconds
        )
    }
    
    fun start() {
        val currentState = _state.value
        if (currentState.isRunning) return
        
        val now = System.currentTimeMillis()
        
        if (currentState.isPaused && currentState.pausedAtMillis != null) {
            // Resume from pause
            val additionalPausedTime = now - currentState.pausedAtMillis
            _state.value = currentState.copy(
                isRunning = true,
                isPaused = false,
                totalPausedMillis = currentState.totalPausedMillis + additionalPausedTime,
                pausedAtMillis = null
            )
        } else {
            // Fresh start
            _state.value = currentState.copy(
                isRunning = true,
                isPaused = false,
                startTimeMillis = now,
                totalPausedMillis = 0L,
                pausedAtMillis = null
            )
        }
    }
    
    fun pause() {
        val currentState = _state.value
        if (!currentState.isRunning || currentState.isPaused) return
        
        _state.value = currentState.copy(
            isRunning = false,
            isPaused = true,
            pausedAtMillis = System.currentTimeMillis()
        )
    }
    
    fun reset() {
        _state.value = createStateForPhase(_state.value.currentPhase)
    }
    
    fun nextPhase() {
        val currentState = _state.value
        val nextPhase = determineNextPhase(currentState.currentPhase, currentState.completedFocusCycles)
        val newCycleCount = if (currentState.currentPhase == PomodoroPhase.FOCUS) {
            currentState.completedFocusCycles + 1
        } else {
            currentState.completedFocusCycles
        }
        
        _state.value = createStateForPhase(nextPhase).copy(completedFocusCycles = newCycleCount)
    }
    
    fun updateFromTimestamp(currentTimeMillis: Long): Boolean {
        val currentState = _state.value
        if (!currentState.isRunning || currentState.startTimeMillis == null) {
            return false
        }
        
        val elapsedMillis = currentTimeMillis - currentState.startTimeMillis - currentState.totalPausedMillis
        val elapsedSeconds = elapsedMillis / 1000.0
        val remainingSeconds = (currentState.totalSeconds - elapsedSeconds).coerceAtLeast(0.0)
        
        _state.value = currentState.copy(remainingSeconds = remainingSeconds)
        
        // Check if phase is complete
        if (remainingSeconds <= 0.0) {
            _state.value = currentState.copy(isRunning = false, remainingSeconds = 0.0)
            return true // Phase complete
        }
        
        return false
    }
    
    private fun determineNextPhase(currentPhase: PomodoroPhase, completedCycles: Int): PomodoroPhase {
        return when (currentPhase) {
            PomodoroPhase.FOCUS -> {
                if ((completedCycles + 1) % settings.cyclesBeforeLongBreak == 0) {
                    PomodoroPhase.LONG_BREAK
                } else {
                    PomodoroPhase.SHORT_BREAK
                }
            }
            PomodoroPhase.SHORT_BREAK, PomodoroPhase.LONG_BREAK -> PomodoroPhase.FOCUS
            PomodoroPhase.CUSTOM -> PomodoroPhase.FOCUS
        }
    }
    
    private fun createStateForPhase(phase: PomodoroPhase): PomodoroTimerState {
        val durationSeconds = when (phase) {
            PomodoroPhase.FOCUS -> settings.focusDurationMinutes * 60
            PomodoroPhase.SHORT_BREAK -> settings.shortBreakDurationMinutes * 60
            PomodoroPhase.LONG_BREAK -> settings.longBreakDurationMinutes * 60
            PomodoroPhase.CUSTOM -> 10 * 60 // Default custom duration
        }.toDouble()
        
        return PomodoroTimerState(
            currentPhase = phase,
            remainingSeconds = durationSeconds,
            totalSeconds = durationSeconds,
            completedFocusCycles = _state.value.completedFocusCycles
        )
    }
    
    fun getCurrentState(): PomodoroTimerState = _state.value
}
