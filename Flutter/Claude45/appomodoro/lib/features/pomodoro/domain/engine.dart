import 'dart:async';
import 'package:flutter/material.dart';
import 'models.dart';

class PomodoroEngine extends ChangeNotifier {
  PomodoroSettings _settings;
  PomodoroState _state;
  Timer? _ticker;

  PomodoroEngine({
    PomodoroSettings? settings,
    PomodoroState? state,
  })  : _settings = settings ?? const PomodoroSettings(),
        _state = state ?? const PomodoroState();

  PomodoroSettings get settings => _settings;
  PomodoroState get state => _state;

  void updateSettings(PomodoroSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void updateState(PomodoroState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Get elapsed seconds since phase start, accounting for pauses
  double getElapsedSeconds() {
    if (!_state.isRunning) {
      return _state.pausedElapsedSeconds.toDouble();
    }

    if (_state.phaseStartTime == null) {
      return 0.0;
    }

    final now = DateTime.now();
    final actualElapsed =
        now.difference(_state.phaseStartTime!).inMilliseconds / 1000.0;
    return actualElapsed;
  }

  /// Get remaining seconds for current phase
  double getRemainingSeconds() {
    final totalDuration = _settings.getDuration(_state.currentPhase) * 60;
    final elapsed = getElapsedSeconds();
    return (totalDuration - elapsed).clamp(0.0, totalDuration.toDouble());
  }

  /// Get remaining time as minutes and seconds
  (int minutes, int seconds) getRemainingTime() {
    final remaining = getRemainingSeconds();
    final minutes = (remaining / 60).floor();
    final seconds = (remaining % 60).floor();
    return (minutes, seconds);
  }

  void start() {
    if (_state.isRunning) return;

    final now = DateTime.now();
    
    _state = _state.copyWith(
      isRunning: true,
      isPaused: false,
      phaseStartTime: now,
      pausedElapsedSeconds: 0,
    );

    _startTicker();
    notifyListeners();
  }

  void pause() {
    if (!_state.isRunning || _state.isPaused) return;

    final elapsed = getElapsedSeconds();
    _stopTicker();

    _state = _state.copyWith(
      isPaused: true,
      pausedElapsedSeconds: elapsed.floor(),
    );

    notifyListeners();
  }

  void resume() {
    if (!_state.isPaused) return;

    final now = DateTime.now();
    final resumeOffset = _state.pausedElapsedSeconds.toDouble();

    _state = _state.copyWith(
      isPaused: false,
      phaseStartTime: now.subtract(Duration(
        milliseconds: (resumeOffset * 1000).toInt(),
      )),
      pausedElapsedSeconds: 0,
    );

    _startTicker();
    notifyListeners();
  }

  void reset() {
    _stopTicker();
    _state = _state.copyWith(
      isRunning: false,
      isPaused: false,
      phaseStartTime: null,
      pausedElapsedSeconds: 0,
    );
    notifyListeners();
  }

  void nextPhase() {
    final wasRunning = _state.isRunning && !_state.isPaused;
    _stopTicker();

    PomodoroPhase nextPhase;
    int newCompletedSessions = _state.completedFocusSessions;

    if (_state.currentPhase == PomodoroPhase.focus) {
      newCompletedSessions++;
      if (newCompletedSessions % _settings.focusSessionsBeforeLongBreak == 0) {
        nextPhase = PomodoroPhase.longBreak;
      } else {
        nextPhase = PomodoroPhase.shortBreak;
      }
    } else {
      nextPhase = PomodoroPhase.focus;
    }

    _state = PomodoroState(
      currentPhase: nextPhase,
      isRunning: false,
      isPaused: false,
      completedFocusSessions: newCompletedSessions,
      phaseStartTime: null,
      pausedElapsedSeconds: 0,
    );

    if (wasRunning && _settings.autoAdvance) {
      // Auto-advance to next phase
      Future.delayed(const Duration(milliseconds: 100), start);
    }

    notifyListeners();
  }

  void setPhase(PomodoroPhase phase) {
    _stopTicker();
    _state = _state.copyWith(
      currentPhase: phase,
      isRunning: false,
      isPaused: false,
      phaseStartTime: null,
      pausedElapsedSeconds: 0,
    );
    notifyListeners();
  }

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      // 60fps = ~16ms
      final remaining = getRemainingSeconds();
      if (remaining <= 0) {
        _onPhaseComplete();
      }
      notifyListeners();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _onPhaseComplete() {
    _stopTicker();
    // Notify via callback (handled by UI layer)
    nextPhase();
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
