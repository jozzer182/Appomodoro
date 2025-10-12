import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:appomodoro/features/pomodoro/domain/models.dart';

class Preferences {
  static const String _accentColorKey = 'accent_color';
  static const String _focusDurationKey = 'focus_duration';
  static const String _shortBreakDurationKey = 'short_break_duration';
  static const String _longBreakDurationKey = 'long_break_duration';
  static const String _autoAdvanceKey = 'auto_advance';
  static const String _notificationsKey = 'notifications';

  Future<void> saveAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.value);
  }

  Future<Color> loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_accentColorKey);
    return colorValue != null ? Color(colorValue) : const Color(0xFFFF6464);
  }

  Future<void> saveSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_focusDurationKey, settings.focusDuration);
    await prefs.setInt(_shortBreakDurationKey, settings.shortBreakDuration);
    await prefs.setInt(_longBreakDurationKey, settings.longBreakDuration);
    await prefs.setBool(_autoAdvanceKey, settings.autoAdvance);
    await prefs.setBool(_notificationsKey, settings.enableNotifications);
  }

  Future<PomodoroSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return PomodoroSettings(
      focusDuration: prefs.getInt(_focusDurationKey) ?? 25,
      shortBreakDuration: prefs.getInt(_shortBreakDurationKey) ?? 5,
      longBreakDuration: prefs.getInt(_longBreakDurationKey) ?? 15,
      autoAdvance: prefs.getBool(_autoAdvanceKey) ?? false,
      enableNotifications: prefs.getBool(_notificationsKey) ?? true,
    );
  }
}
