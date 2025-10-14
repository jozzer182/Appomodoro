import 'dart:ui';

enum Phase { focus, shortBreak, longBreak, custom }

class Presets {
  final Duration focus;
  final Duration shortBreak;
  final Duration longBreak;
  final Duration custom;
  final bool autoAdvance;
  final Color accent;
  const Presets({
    this.focus = const Duration(minutes: 25),
    this.shortBreak = const Duration(minutes: 5),
    this.longBreak = const Duration(minutes: 15),
    this.custom = const Duration(minutes: 20),
    this.autoAdvance = true,
    this.accent = const Color(0xFF5AC8FA),
  });

  Presets copyWith({
    Duration? focus,
    Duration? shortBreak,
    Duration? longBreak,
    Duration? custom,
    bool? autoAdvance,
    Color? accent,
  }) => Presets(
    focus: focus ?? this.focus,
    shortBreak: shortBreak ?? this.shortBreak,
    longBreak: longBreak ?? this.longBreak,
    custom: custom ?? this.custom,
    autoAdvance: autoAdvance ?? this.autoAdvance,
    accent: accent ?? this.accent,
  );
}
