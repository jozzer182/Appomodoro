package com.zarabandajose.appomodoro.model

import kotlin.math.max

/**
 * Immutable snapshot of the timer that still carries the raw timestamps required for
 * frame-accurate rendering inside the dial.
 */
data class PomodoroTimerState(
    val phase: PomodoroPhase,
    val phaseDurationMillis: Long,
    val elapsedMillisSnapshot: Long,
    val phaseStartEpochMillis: Long?,
    val accumulatedPauseMillis: Long,
    val pausedAtEpochMillis: Long?,
    val isRunning: Boolean,
    val focusSessionsCompleted: Int,
    val cycleCount: Int,
    val autoAdvance: Boolean,
    val notificationsEnabled: Boolean
) {
    val remainingMillis: Long
        get() = max(0L, phaseDurationMillis - elapsedMillisSnapshot)

    val hasStarted: Boolean
        get() = phaseStartEpochMillis != null

    val isPaused: Boolean
        get() = hasStarted && !isRunning && remainingMillis > 0L

    fun elapsedMillis(atEpochMillis: Long): Long {
        val start = phaseStartEpochMillis ?: return elapsedMillisSnapshot
        val referenceNow = pausedAtEpochMillis ?: atEpochMillis
        val raw = referenceNow - start - accumulatedPauseMillis
        return max(0L, raw)
    }

    fun expectedEndEpochMillis(): Long? {
        val start = phaseStartEpochMillis ?: return null
        return start + phaseDurationMillis + accumulatedPauseMillis
    }

    fun withElapsed(elapsedMillis: Long): PomodoroTimerState = copy(
        elapsedMillisSnapshot = elapsedMillis.coerceAtLeast(0L)
    )

    companion object {
        fun initial(settings: PomodoroSettings): PomodoroTimerState = PomodoroTimerState(
            phase = PomodoroPhase.Focus,
            phaseDurationMillis = settings.focusMinutes * 60_000L,
            elapsedMillisSnapshot = 0L,
            phaseStartEpochMillis = null,
            accumulatedPauseMillis = 0L,
            pausedAtEpochMillis = null,
            isRunning = false,
            focusSessionsCompleted = 0,
            cycleCount = 0,
            autoAdvance = settings.autoAdvance,
            notificationsEnabled = settings.notificationsEnabled
        )
    }
}
