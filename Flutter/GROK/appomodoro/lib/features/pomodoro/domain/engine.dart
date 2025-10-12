import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PomodoroEngine extends ChangeNotifier {
  PomodoroState _state = const PomodoroState();
  PomodoroSettings _settings = const PomodoroSettings();
  Timer? _timer;
  Stopwatch _stopwatch = Stopwatch();

  PomodoroState get state => _state;
  PomodoroSettings get settings => _settings;

  void updateSettings(PomodoroSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void start() {
    if (_state.isRunning) return;
    _state = _state.copyWith(
      isRunning: true,
      isPaused: false,
      startTime: DateTime.now(),
      pauseTime: null,
    );
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 16), _tick); // ~60 fps
    notifyListeners();
  }

  void pause() {
    if (!_state.isRunning || _state.isPaused) return;
    _state = _state.copyWith(
      isPaused: true,
      pauseTime: DateTime.now(),
    );
    _stopwatch.stop();
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (!_state.isPaused) return;
    _state = _state.copyWith(
      isPaused: false,
      pauseTime: null,
    );
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 16), _tick);
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _stopwatch.reset();
    _state = _state.copyWith(
      isRunning: false,
      isPaused: false,
      remainingSeconds: _getDurationForPhase(_state.currentPhase),
      totalSeconds: _getDurationForPhase(_state.currentPhase),
      startTime: null,
      pauseTime: null,
    );
    notifyListeners();
  }

  void nextPhase() {
    Phase nextPhase;
    int completed = _state.completedSessions;
    if (_state.currentPhase == Phase.focus) {
      completed++;
      if (completed % 4 == 0) {
        nextPhase = Phase.longBreak;
      } else {
        nextPhase = Phase.shortBreak;
      }
    } else {
      nextPhase = Phase.focus;
    }
    _state = _state.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: _getDurationForPhase(nextPhase),
      totalSeconds: _getDurationForPhase(nextPhase),
      completedSessions: completed,
      isRunning: false,
      isPaused: false,
      startTime: null,
      pauseTime: null,
    );
    _timer?.cancel();
    _stopwatch.reset();
    notifyListeners();
  }

  void _tick(Timer timer) {
    final elapsedMs = _stopwatch.elapsedMilliseconds;
    final elapsedSec = elapsedMs / 1000.0;
    final remaining = (_state.totalSeconds - elapsedSec).clamp(0.0, _state.totalSeconds.toDouble()).toInt();
    _state = _state.copyWith(remainingSeconds: remaining);
    if (remaining == 0) {
      _onPhaseEnd();
    }
    notifyListeners();
  }

  void _onPhaseEnd() {
    _timer?.cancel();
    _stopwatch.reset();
    if (_settings.notificationsEnabled) {
      _showNotification();
    }
    if (_settings.autoAdvance) {
      nextPhase();
      start();
    } else {
      _state = _state.copyWith(isRunning: false);
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Timer',
      channelDescription: 'Notifications for Pomodoro timer phases',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Phase Complete',
      '${_phaseName(_state.currentPhase)} is finished!',
      platformChannelSpecifics,
    );
  }

  String _phaseName(Phase phase) {
    switch (phase) {
      case Phase.focus:
        return 'Focus';
      case Phase.shortBreak:
        return 'Short Break';
      case Phase.longBreak:
        return 'Long Break';
      case Phase.custom:
        return 'Custom';
    }
  }

  int _getDurationForPhase(Phase phase) {
    switch (phase) {
      case Phase.focus:
        return _settings.focusMinutes * 60;
      case Phase.shortBreak:
        return _settings.shortBreakMinutes * 60;
      case Phase.longBreak:
        return _settings.longBreakMinutes * 60;
      case Phase.custom:
        return _settings.customMinutes * 60;
    }
  }

  double get elapsedSeconds => _stopwatch.elapsedMilliseconds / 1000.0;
}