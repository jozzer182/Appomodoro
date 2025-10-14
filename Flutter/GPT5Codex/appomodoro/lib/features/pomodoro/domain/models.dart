import 'dart:ui';

import 'package:flutter/foundation.dart';

enum PomodoroPhaseType { focus, shortBreak, longBreak, custom }

enum PomodoroStatus { idle, running, paused, finished }

@immutable
class PomodoroDurations {
  const PomodoroDurations({
    required this.focus,
    required this.shortBreak,
    required this.longBreak,
    required this.custom,
    required this.cyclesUntilLongBreak,
  })  : assert(focus > Duration.zero),
        assert(shortBreak > Duration.zero),
        assert(longBreak > Duration.zero),
        assert(custom > Duration.zero),
        assert(cyclesUntilLongBreak > 0);

  final Duration focus;
  final Duration shortBreak;
  final Duration longBreak;
  final Duration custom;
  final int cyclesUntilLongBreak;

  PomodoroDurations copyWith({
    Duration? focus,
    Duration? shortBreak,
    Duration? longBreak,
    Duration? custom,
    int? cyclesUntilLongBreak,
  }) {
    return PomodoroDurations(
      focus: focus ?? this.focus,
      shortBreak: shortBreak ?? this.shortBreak,
      longBreak: longBreak ?? this.longBreak,
      custom: custom ?? this.custom,
      cyclesUntilLongBreak: cyclesUntilLongBreak ?? this.cyclesUntilLongBreak,
    );
  }
}

@immutable
class PomodoroSettings {
  const PomodoroSettings({
    required this.durations,
    required this.autoAdvance,
    required this.notificationsEnabled,
    required this.vibrationEnabled,
    required this.accentColor,
  });

  factory PomodoroSettings.defaults() {
    return PomodoroSettings(
      durations: const PomodoroDurations(
        focus: const Duration(minutes: 25),
        shortBreak: const Duration(minutes: 5),
        longBreak: const Duration(minutes: 15),
        custom: const Duration(minutes: 20),
        cyclesUntilLongBreak: 4,
      ),
      autoAdvance: true,
      notificationsEnabled: true,
      vibrationEnabled: true,
      accentColor: const Color(0xFF6C5CE7),
    );
  }

  final PomodoroDurations durations;
  final bool autoAdvance;
  final bool notificationsEnabled;
  final bool vibrationEnabled;
  final Color accentColor;

  PomodoroSettings copyWith({
    PomodoroDurations? durations,
    bool? autoAdvance,
    bool? notificationsEnabled,
    bool? vibrationEnabled,
    Color? accentColor,
  }) {
    return PomodoroSettings(
      durations: durations ?? this.durations,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

@immutable
class PomodoroPhase {
  const PomodoroPhase({
    required this.type,
    required this.duration,
  });

  final PomodoroPhaseType type;
  final Duration duration;

  PomodoroPhase copyWith({
    PomodoroPhaseType? type,
    Duration? duration,
  }) => PomodoroPhase(
        type: type ?? this.type,
        duration: duration ?? this.duration,
      );
}

@immutable
class PomodoroRuntime {
  const PomodoroRuntime({
    required this.phase,
    required this.status,
    required this.elapsed,
    required this.completedFocusCycles,
  });

  factory PomodoroRuntime.initial(PomodoroDurations durations) {
    return PomodoroRuntime(
      phase: PomodoroPhase(type: PomodoroPhaseType.focus, duration: durations.focus),
      status: PomodoroStatus.idle,
      elapsed: Duration.zero,
      completedFocusCycles: 0,
    );
  }

  final PomodoroPhase phase;
  final PomodoroStatus status;
  final Duration elapsed;
  final int completedFocusCycles;

  Duration get remaining {
    final remaining = phase.duration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get progress => phase.duration.inMilliseconds == 0
      ? 0
      : (elapsed.inMilliseconds / phase.duration.inMilliseconds).clamp(0.0, 1.0);

  PomodoroRuntime copyWith({
    PomodoroPhase? phase,
    PomodoroStatus? status,
    Duration? elapsed,
    int? completedFocusCycles,
  }) {
    return PomodoroRuntime(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      completedFocusCycles: completedFocusCycles ?? this.completedFocusCycles,
    );
  }
}

@immutable
class PomodoroSnapshot {
  const PomodoroSnapshot({
    required this.settings,
    required this.runtime,
    required this.lastUpdated,
  });

  final PomodoroSettings settings;
  final PomodoroRuntime runtime;
  final DateTime lastUpdated;

  Duration get remaining => runtime.remaining;
  Duration get elapsed => runtime.elapsed;

  PomodoroSnapshot copyWith({
    PomodoroSettings? settings,
    PomodoroRuntime? runtime,
    DateTime? lastUpdated,
  }) {
    return PomodoroSnapshot(
      settings: settings ?? this.settings,
      runtime: runtime ?? this.runtime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
