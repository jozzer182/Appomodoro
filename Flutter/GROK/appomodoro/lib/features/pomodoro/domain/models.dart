import 'package:flutter/material.dart';

enum Phase {
  focus,
  shortBreak,
  longBreak,
  custom,
}

class PomodoroSettings {
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int customMinutes;
  final bool autoAdvance;
  final bool notificationsEnabled;
  final Color accentColor;

  const PomodoroSettings({
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 10,
    this.customMinutes = 15,
    this.autoAdvance = false,
    this.notificationsEnabled = true,
    this.accentColor = const Color(0xFFFF6464),
  });

  PomodoroSettings copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? customMinutes,
    bool? autoAdvance,
    bool? notificationsEnabled,
    Color? accentColor,
  }) {
    return PomodoroSettings(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      customMinutes: customMinutes ?? this.customMinutes,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

class PomodoroState {
  final Phase currentPhase;
  final bool isRunning;
  final bool isPaused;
  final int remainingSeconds;
  final int totalSeconds;
  final DateTime? startTime;
  final DateTime? pauseTime;
  final int completedSessions;

  const PomodoroState({
    this.currentPhase = Phase.focus,
    this.isRunning = false,
    this.isPaused = false,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.startTime,
    this.pauseTime,
    this.completedSessions = 0,
  });

  PomodoroState copyWith({
    Phase? currentPhase,
    bool? isRunning,
    bool? isPaused,
    int? remainingSeconds,
    int? totalSeconds,
    DateTime? startTime,
    DateTime? pauseTime,
    int? completedSessions,
  }) {
    return PomodoroState(
      currentPhase: currentPhase ?? this.currentPhase,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      startTime: startTime ?? this.startTime,
      pauseTime: pauseTime ?? this.pauseTime,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  int get minutes => remainingSeconds ~/ 60;
  int get seconds => remainingSeconds % 60;
}