import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';

class PomodoroPreferences {
  PomodoroPreferences(this._preferences);

  static const String _prefix = 'pomodoro.';
  static const String _accentColorKey = '${_prefix}accent_color';
  static const String _focusMinutesKey = '${_prefix}focus_minutes';
  static const String _shortBreakMinutesKey = '${_prefix}short_break_minutes';
  static const String _longBreakMinutesKey = '${_prefix}long_break_minutes';
  static const String _customMinutesKey = '${_prefix}custom_minutes';
  static const String _cyclesKey = '${_prefix}cycles_until_long_break';
  static const String _autoAdvanceKey = '${_prefix}auto_advance';
  static const String _notificationsKey = '${_prefix}notifications_enabled';
  static const String _vibrationKey = '${_prefix}vibration_enabled';

  static const String _timerPhaseKey = '${_prefix}timer.phase';
  static const String _timerDurationMsKey = '${_prefix}timer.duration_ms';
  static const String _timerElapsedMsKey = '${_prefix}timer.elapsed_ms';
  static const String _timerStatusKey = '${_prefix}timer.status';
  static const String _timerStartEpochKey = '${_prefix}timer.start_epoch_ms';
  static const String _timerFocusCyclesKey = '${_prefix}timer.focus_cycles';

  final SharedPreferences _preferences;

  PomodoroSettings loadSettings() {
    final defaults = PomodoroSettings.defaults();
    final accentValue = _preferences.getInt(_accentColorKey);
    final focus = _preferences.getInt(_focusMinutesKey);
    final shortBreak = _preferences.getInt(_shortBreakMinutesKey);
    final longBreak = _preferences.getInt(_longBreakMinutesKey);
    final custom = _preferences.getInt(_customMinutesKey);
    final cycles = _preferences.getInt(_cyclesKey);

    final durations = defaults.durations.copyWith(
      focus: focus != null ? Duration(minutes: focus) : null,
      shortBreak: shortBreak != null ? Duration(minutes: shortBreak) : null,
      longBreak: longBreak != null ? Duration(minutes: longBreak) : null,
      custom: custom != null ? Duration(minutes: custom) : null,
      cyclesUntilLongBreak: cycles,
    );

    return defaults.copyWith(
      durations: durations,
      autoAdvance: _preferences.getBool(_autoAdvanceKey) ?? defaults.autoAdvance,
      notificationsEnabled:
          _preferences.getBool(_notificationsKey) ?? defaults.notificationsEnabled,
      vibrationEnabled: _preferences.getBool(_vibrationKey) ?? defaults.vibrationEnabled,
      accentColor: accentValue != null ? Color(accentValue) : defaults.accentColor,
    );
  }

  Future<void> saveSettings(PomodoroSettings settings) async {
    await Future.wait(<Future<bool>>[
      _preferences.setInt(_accentColorKey, settings.accentColor.value),
      _preferences.setInt(
        _focusMinutesKey,
        settings.durations.focus.inMinutes,
      ),
      _preferences.setInt(
        _shortBreakMinutesKey,
        settings.durations.shortBreak.inMinutes,
      ),
      _preferences.setInt(
        _longBreakMinutesKey,
        settings.durations.longBreak.inMinutes,
      ),
      _preferences.setInt(
        _customMinutesKey,
        settings.durations.custom.inMinutes,
      ),
      _preferences.setInt(
        _cyclesKey,
        settings.durations.cyclesUntilLongBreak,
      ),
      _preferences.setBool(_autoAdvanceKey, settings.autoAdvance),
      _preferences.setBool(_notificationsKey, settings.notificationsEnabled),
      _preferences.setBool(_vibrationKey, settings.vibrationEnabled),
    ]);
  }

  PomodoroTimerPersistence? loadTimer() {
    final phaseName = _preferences.getString(_timerPhaseKey);
    final durationMs = _preferences.getInt(_timerDurationMsKey);

    if (phaseName == null || durationMs == null) {
      return null;
    }

    final statusName = _preferences.getString(_timerStatusKey);
    final elapsedMs = _preferences.getInt(_timerElapsedMsKey) ?? 0;
    final startEpoch = _preferences.getInt(_timerStartEpochKey);
    final focusCycles = _preferences.getInt(_timerFocusCyclesKey) ?? 0;

    return PomodoroTimerPersistence(
      phaseType: _enumFromString<PomodoroPhaseType>(
          PomodoroPhaseType.values, phaseName, PomodoroPhaseType.focus),
      phaseDuration: Duration(milliseconds: durationMs),
      elapsed: Duration(milliseconds: elapsedMs),
      status: _enumFromString<PomodoroStatus>(
          PomodoroStatus.values, statusName, PomodoroStatus.idle),
      phaseStartEpochMs: startEpoch,
      completedFocusCycles: focusCycles,
    );
  }

  Future<void> clearTimer() async {
    await Future.wait(<Future<bool>>[
      _preferences.remove(_timerPhaseKey),
      _preferences.remove(_timerDurationMsKey),
      _preferences.remove(_timerElapsedMsKey),
      _preferences.remove(_timerStatusKey),
      _preferences.remove(_timerStartEpochKey),
      _preferences.remove(_timerFocusCyclesKey),
    ]);
  }

  Future<void> saveTimer(PomodoroTimerPersistence data) async {
    await Future.wait(<Future<bool>>[
  _preferences.setString(_timerPhaseKey, describeEnum(data.phaseType)),
  _preferences.setInt(_timerDurationMsKey, data.phaseDuration.inMilliseconds),
  _preferences.setInt(_timerElapsedMsKey, data.elapsed.inMilliseconds),
  _preferences.setString(_timerStatusKey, describeEnum(data.status)),
      if (data.phaseStartEpochMs != null)
        _preferences.setInt(_timerStartEpochKey, data.phaseStartEpochMs!)
      else
        _preferences.remove(_timerStartEpochKey),
      _preferences.setInt(_timerFocusCyclesKey, data.completedFocusCycles),
    ]);
  }

  T _enumFromString<T extends Enum>(List<T> values, String? value, T fallback) {
    if (value == null) {
      return fallback;
    }
    for (final candidate in values) {
      if (describeEnum(candidate) == value) {
        return candidate;
      }
    }
    return fallback;
  }
}

class PomodoroTimerPersistence {
  PomodoroTimerPersistence({
    required this.phaseType,
    required this.phaseDuration,
    required this.elapsed,
    required this.status,
    required this.completedFocusCycles,
    required this.phaseStartEpochMs,
  });

  final PomodoroPhaseType phaseType;
  final Duration phaseDuration;
  final Duration elapsed;
  final PomodoroStatus status;
  final int completedFocusCycles;
  final int? phaseStartEpochMs;

  PomodoroTimerPersistence copyWith({
    PomodoroPhaseType? phaseType,
    Duration? phaseDuration,
    Duration? elapsed,
    PomodoroStatus? status,
    int? completedFocusCycles,
    int? phaseStartEpochMs,
    bool clearStartEpoch = false,
  }) {
    return PomodoroTimerPersistence(
      phaseType: phaseType ?? this.phaseType,
      phaseDuration: phaseDuration ?? this.phaseDuration,
      elapsed: elapsed ?? this.elapsed,
      status: status ?? this.status,
      completedFocusCycles: completedFocusCycles ?? this.completedFocusCycles,
      phaseStartEpochMs: clearStartEpoch ? null : (phaseStartEpochMs ?? this.phaseStartEpochMs),
    );
  }
}
