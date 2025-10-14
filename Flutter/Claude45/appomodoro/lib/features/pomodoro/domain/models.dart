enum PomodoroPhase {
  focus,
  shortBreak,
  longBreak,
  custom;

  String get displayName {
    switch (this) {
      case PomodoroPhase.focus:
        return 'Focus';
      case PomodoroPhase.shortBreak:
        return 'Short Break';
      case PomodoroPhase.longBreak:
        return 'Long Break';
      case PomodoroPhase.custom:
        return 'Custom';
    }
  }
}

class PomodoroSettings {
  final int focusDuration; // minutes
  final int shortBreakDuration; // minutes
  final int longBreakDuration; // minutes
  final int customDuration; // minutes
  final int focusSessionsBeforeLongBreak;
  final bool autoAdvance;
  final bool notificationsEnabled;
  final int accentColorValue;

  const PomodoroSettings({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.customDuration = 10,
    this.focusSessionsBeforeLongBreak = 4,
    this.autoAdvance = false,
    this.notificationsEnabled = true,
    this.accentColorValue = 0xFF00BCD4,
  });

  PomodoroSettings copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? customDuration,
    int? focusSessionsBeforeLongBreak,
    bool? autoAdvance,
    bool? notificationsEnabled,
    int? accentColorValue,
  }) {
    return PomodoroSettings(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      customDuration: customDuration ?? this.customDuration,
      focusSessionsBeforeLongBreak:
          focusSessionsBeforeLongBreak ?? this.focusSessionsBeforeLongBreak,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      accentColorValue: accentColorValue ?? this.accentColorValue,
    );
  }

  int getDuration(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return focusDuration;
      case PomodoroPhase.shortBreak:
        return shortBreakDuration;
      case PomodoroPhase.longBreak:
        return longBreakDuration;
      case PomodoroPhase.custom:
        return customDuration;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'customDuration': customDuration,
      'focusSessionsBeforeLongBreak': focusSessionsBeforeLongBreak,
      'autoAdvance': autoAdvance,
      'notificationsEnabled': notificationsEnabled,
      'accentColorValue': accentColorValue,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      focusDuration: json['focusDuration'] as int? ?? 25,
      shortBreakDuration: json['shortBreakDuration'] as int? ?? 5,
      longBreakDuration: json['longBreakDuration'] as int? ?? 15,
      customDuration: json['customDuration'] as int? ?? 10,
      focusSessionsBeforeLongBreak:
          json['focusSessionsBeforeLongBreak'] as int? ?? 4,
      autoAdvance: json['autoAdvance'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      accentColorValue: json['accentColorValue'] as int? ?? 0xFF00BCD4,
    );
  }
}

class PomodoroState {
  final PomodoroPhase currentPhase;
  final bool isRunning;
  final bool isPaused;
  final int completedFocusSessions;
  final DateTime? phaseStartTime;
  final int pausedElapsedSeconds;

  const PomodoroState({
    this.currentPhase = PomodoroPhase.focus,
    this.isRunning = false,
    this.isPaused = false,
    this.completedFocusSessions = 0,
    this.phaseStartTime,
    this.pausedElapsedSeconds = 0,
  });

  PomodoroState copyWith({
    PomodoroPhase? currentPhase,
    bool? isRunning,
    bool? isPaused,
    int? completedFocusSessions,
    DateTime? phaseStartTime,
    int? pausedElapsedSeconds,
  }) {
    return PomodoroState(
      currentPhase: currentPhase ?? this.currentPhase,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      completedFocusSessions:
          completedFocusSessions ?? this.completedFocusSessions,
      phaseStartTime: phaseStartTime ?? this.phaseStartTime,
      pausedElapsedSeconds: pausedElapsedSeconds ?? this.pausedElapsedSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPhase': currentPhase.index,
      'isRunning': isRunning,
      'isPaused': isPaused,
      'completedFocusSessions': completedFocusSessions,
      'phaseStartTime': phaseStartTime?.millisecondsSinceEpoch,
      'pausedElapsedSeconds': pausedElapsedSeconds,
    };
  }

  factory PomodoroState.fromJson(Map<String, dynamic> json) {
    return PomodoroState(
      currentPhase:
          PomodoroPhase.values[json['currentPhase'] as int? ?? 0],
      isRunning: json['isRunning'] as bool? ?? false,
      isPaused: json['isPaused'] as bool? ?? false,
      completedFocusSessions: json['completedFocusSessions'] as int? ?? 0,
      phaseStartTime: json['phaseStartTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['phaseStartTime'] as int)
          : null,
      pausedElapsedSeconds: json['pausedElapsedSeconds'] as int? ?? 0,
    );
  }
}
