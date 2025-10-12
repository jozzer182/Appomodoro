import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:appomodoro/features/pomodoro/domain/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroEngine extends ChangeNotifier {
  late PomodoroSettings _settings;
  PomodoroState _state = PomodoroState(
    phase: PomodoroPhase.focus,
    remainingTime: Duration(minutes: 25),
  );

  Timer? _timer;
  DateTime? _endTime;
  
  PomodoroState get state => _state;

  PomodoroEngine() {
    _loadState();
  }

  void start() {
    if (_state.isRunning) return;

    final duration = _getDurationForPhase(_state.phase);
    _endTime = DateTime.now().add(duration);
    _state = PomodoroState(
      phase: _state.phase,
      remainingTime: duration,
      isRunning: true,
      sessionCount: _state.sessionCount,
    );
    _saveState();

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _tick();
    });
    notifyListeners();
  }

  void pause() {
    if (!_state.isRunning) return;
    _timer?.cancel();
    _state = PomodoroState(
      phase: _state.phase,
      remainingTime: _endTime!.difference(DateTime.now()),
      isRunning: false,
      sessionCount: _state.sessionCount,
    );
    _saveState();
    notifyListeners();
  }
  
  void resume() {
    if (_state.isRunning) return;
    _endTime = DateTime.now().add(_state.remainingTime);
    _state = PomodoroState(
      phase: _state.phase,
      remainingTime: _state.remainingTime,
      isRunning: true,
      sessionCount: _state.sessionCount,
    );
    _saveState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _tick();
    });
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _state = PomodoroState(
      phase: PomodoroPhase.focus,
      remainingTime: _getDurationForPhase(PomodoroPhase.focus),
      isRunning: false,
      sessionCount: 0,
    );
    _saveState();
    notifyListeners();
  }

  void _tick() {
    final now = DateTime.now();
    if (now.isAfter(_endTime!)) {
      _timer?.cancel();
      _moveToNextPhase();
    } else {
      _state = PomodoroState(
        phase: _state.phase,
        remainingTime: _endTime!.difference(now),
        isRunning: true,
        sessionCount: _state.sessionCount,
      );
      notifyListeners();
    }
  }

  void _moveToNextPhase() {
    // Logic to move to the next phase
    notifyListeners();
  }

  Duration _getDurationForPhase(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return Duration(minutes: _settings.focusDuration);
      case PomodoroPhase.shortBreak:
        return Duration(minutes: _settings.shortBreakDuration);
      case PomodoroPhase.longBreak:
        return Duration(minutes: _settings.longBreakDuration);
      default:
        return Duration(minutes: _settings.focusDuration);
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_endTime != null) {
      await prefs.setInt('endTime', _endTime!.millisecondsSinceEpoch);
    }
    await prefs.setInt('phase', _state.phase.index);
    await prefs.setBool('isRunning', _state.isRunning);
    await prefs.setInt('sessionCount', _state.sessionCount);
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMillis = prefs.getInt('endTime');
    final phaseIndex = prefs.getInt('phase') ?? 0;
    final isRunning = prefs.getBool('isRunning') ?? false;
    final sessionCount = prefs.getInt('sessionCount') ?? 0;

    final phase = PomodoroPhase.values[phaseIndex];
    
    if (endTimeMillis != null) {
      _endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
      final remaining = _endTime!.difference(DateTime.now());

      if (remaining.isNegative) {
        // Timer finished while app was closed
        _moveToNextPhase();
      } else {
         _state = PomodoroState(
          phase: phase,
          remainingTime: remaining,
          isRunning: isRunning,
          sessionCount: sessionCount,
        );
        if (isRunning) {
          resume();
        }
      }
    } else {
      _state = PomodoroState(
        phase: phase,
        remainingTime: _getDurationForPhase(phase),
        isRunning: false,
        sessionCount: sessionCount,
      );
    }
    notifyListeners();
  }
}
