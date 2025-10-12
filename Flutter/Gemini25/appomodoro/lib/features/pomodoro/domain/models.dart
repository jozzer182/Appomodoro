enum PomodoroPhase { focus, shortBreak, longBreak, custom }

class PomodoroSettings {
  final int focusDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final bool autoAdvance;
  final bool enableNotifications;

  PomodoroSettings({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.autoAdvance = false,
    this.enableNotifications = true,
  });
}

class PomodoroState {
  final PomodoroPhase phase;
  final Duration remainingTime;
  final bool isRunning;
  final int sessionCount;

  PomodoroState({
    required this.phase,
    required this.remainingTime,
    this.isRunning = false,
    this.sessionCount = 0,
  });
}
