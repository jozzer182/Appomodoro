package com.zarabandajose.appomodoro.domain

import com.zarabandajose.appomodoro.model.PomodoroPhase
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import kotlin.math.max
import kotlin.math.min

class PomodoroEngine(
    private val timeProvider: () -> Long = { System.currentTimeMillis() }
) {

    private var currentPhase: PomodoroPhase = PomodoroPhase.Focus
    private var phaseDurationMillis: Long = PomodoroSettings.Default.focusMinutes * 60_000L
    private var phaseStartEpochMillis: Long? = null
    private var accumulatedPauseMillis: Long = 0L
    private var pausedAtEpochMillis: Long? = null
    private var isRunning: Boolean = false
    private var completionHandled: Boolean = false
    private var focusSessionsCompleted: Int = 0

    fun snapshot(settings: PomodoroSettings, nowMillis: Long = timeProvider()): PomodoroTimerState {
        val elapsed = min(calculateElapsed(nowMillis), phaseDurationMillis)
        return PomodoroTimerState(
            phase = currentPhase,
            phaseDurationMillis = phaseDurationMillis,
            elapsedMillisSnapshot = elapsed,
            phaseStartEpochMillis = phaseStartEpochMillis,
            accumulatedPauseMillis = accumulatedPauseMillis,
            pausedAtEpochMillis = pausedAtEpochMillis,
            isRunning = isRunning,
            focusSessionsCompleted = focusSessionsCompleted,
            cycleCount = focusSessionsCompleted / 4,
            autoAdvance = settings.autoAdvance,
            notificationsEnabled = settings.notificationsEnabled
        )
    }

    fun onSettingsChanged(settings: PomodoroSettings, nowMillis: Long = timeProvider()): PomodoroTimerState {
        phaseDurationMillis = durationForPhase(currentPhase, settings)
        val elapsed = calculateElapsed(nowMillis)
        if (elapsed >= phaseDurationMillis) {
            completionHandled = false
        }
        return snapshot(settings, nowMillis)
    }

    fun selectPhase(
        phase: PomodoroPhase,
        settings: PomodoroSettings,
        nowMillis: Long = timeProvider()
    ): PomodoroTimerState {
        currentPhase = phase
        phaseDurationMillis = durationForPhase(phase, settings)
        phaseStartEpochMillis = null
        accumulatedPauseMillis = 0L
        pausedAtEpochMillis = null
        isRunning = false
        completionHandled = false
        return snapshot(settings, nowMillis)
    }

    fun startOrResume(settings: PomodoroSettings, nowMillis: Long = timeProvider()): PomodoroTimerState {
        if (phaseStartEpochMillis == null) {
            phaseStartEpochMillis = nowMillis
            accumulatedPauseMillis = 0L
        } else if (pausedAtEpochMillis != null) {
            accumulatedPauseMillis += nowMillis - pausedAtEpochMillis!!
            pausedAtEpochMillis = null
        }
        isRunning = true
        completionHandled = false
        return snapshot(settings, nowMillis)
    }

    fun pause(settings: PomodoroSettings, nowMillis: Long = timeProvider()): PomodoroTimerState {
        if (isRunning) {
            pausedAtEpochMillis = nowMillis
            isRunning = false
        }
        return snapshot(settings, nowMillis)
    }

    fun reset(settings: PomodoroSettings, nowMillis: Long = timeProvider()): PomodoroTimerState {
        currentPhase = PomodoroPhase.Focus
        phaseDurationMillis = durationForPhase(currentPhase, settings)
        phaseStartEpochMillis = null
        accumulatedPauseMillis = 0L
        pausedAtEpochMillis = null
        isRunning = false
        completionHandled = false
        focusSessionsCompleted = 0
        return snapshot(settings, nowMillis)
    }

    fun skipToNextPhase(
        settings: PomodoroSettings,
        nowMillis: Long = timeProvider(),
        startImmediately: Boolean
    ): PomodoroTimerState {
        val completedPhase = currentPhase
        if (completedPhase == PomodoroPhase.Focus) {
            recordFocusCompletion()
        }
        val next = resolveNextPhase(completedPhase)
        return selectPhaseInternal(next, settings, nowMillis, startImmediately)
    }

    fun onTick(settings: PomodoroSettings, nowMillis: Long = timeProvider()): TickOutcome {
        val state = snapshot(settings, nowMillis)
        val justCompleted = !completionHandled && state.hasStarted && state.remainingMillis == 0L && phaseDurationMillis > 0
        if (justCompleted) {
            completionHandled = true
            isRunning = false
        }
        val adjustedState = if (justCompleted) {
            state.copy(isRunning = false, elapsedMillisSnapshot = phaseDurationMillis)
        } else {
            state
        }
        return TickOutcome(adjustedState, if (justCompleted) currentPhase else null)
    }

    fun handleCompletion(
        settings: PomodoroSettings,
        autoAdvance: Boolean,
        nowMillis: Long = timeProvider()
    ): PomodoroTimerState {
        val finishedPhase = currentPhase
        if (finishedPhase == PomodoroPhase.Focus) {
            recordFocusCompletion()
        }
        return if (autoAdvance) {
            val nextPhase = resolveNextPhase(finishedPhase)
            selectPhaseInternal(nextPhase, settings, nowMillis, startImmediately = true)
        } else {
            val nextPhase = resolveNextPhase(finishedPhase)
            selectPhaseInternal(nextPhase, settings, nowMillis, startImmediately = false)
        }
    }

    data class TickOutcome(
        val state: PomodoroTimerState,
        val completedPhase: PomodoroPhase?
    )

    private fun selectPhaseInternal(
        phase: PomodoroPhase,
        settings: PomodoroSettings,
        nowMillis: Long,
        startImmediately: Boolean
    ): PomodoroTimerState {
        currentPhase = phase
        phaseDurationMillis = durationForPhase(phase, settings)
        completionHandled = false
        accumulatedPauseMillis = 0L
        if (startImmediately) {
            phaseStartEpochMillis = nowMillis
            pausedAtEpochMillis = null
            isRunning = true
        } else {
            phaseStartEpochMillis = null
            pausedAtEpochMillis = null
            isRunning = false
        }
        return snapshot(settings, nowMillis)
    }

    private fun durationForPhase(phase: PomodoroPhase, settings: PomodoroSettings): Long {
        val minutes = when (phase) {
            PomodoroPhase.Focus -> settings.focusMinutes
            PomodoroPhase.ShortBreak -> settings.shortBreakMinutes
            PomodoroPhase.LongBreak -> settings.longBreakMinutes
            PomodoroPhase.Custom -> settings.customMinutes
        }
        return max(1, minutes) * 60_000L
    }

    private fun resolveNextPhase(completedPhase: PomodoroPhase): PomodoroPhase = when (completedPhase) {
        PomodoroPhase.Focus -> if (focusSessionsCompleted % 4 == 0 && focusSessionsCompleted > 0) {
            PomodoroPhase.LongBreak
        } else {
            PomodoroPhase.ShortBreak
        }
        PomodoroPhase.ShortBreak, PomodoroPhase.LongBreak -> PomodoroPhase.Focus
        PomodoroPhase.Custom -> PomodoroPhase.Focus
    }

    private fun recordFocusCompletion() {
        focusSessionsCompleted += 1
    }

    private fun calculateElapsed(nowMillis: Long): Long {
        val start = phaseStartEpochMillis ?: return 0L
        val referenceNow = pausedAtEpochMillis ?: nowMillis
        return max(0L, referenceNow - start - accumulatedPauseMillis)
    }
}
