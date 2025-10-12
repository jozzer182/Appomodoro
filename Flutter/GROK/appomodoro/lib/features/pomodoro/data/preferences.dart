import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../domain/models.dart';

class PreferencesService {
  static const String _focusMinutesKey = 'focus_minutes';
  static const String _shortBreakMinutesKey = 'short_break_minutes';
  static const String _longBreakMinutesKey = 'long_break_minutes';
  static const String _customMinutesKey = 'custom_minutes';
  static const String _autoAdvanceKey = 'auto_advance';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _accentColorKey = 'accent_color';

  Future<PomodoroSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return PomodoroSettings(
      focusMinutes: prefs.getInt(_focusMinutesKey) ?? 25,
      shortBreakMinutes: prefs.getInt(_shortBreakMinutesKey) ?? 5,
      longBreakMinutes: prefs.getInt(_longBreakMinutesKey) ?? 10,
      customMinutes: prefs.getInt(_customMinutesKey) ?? 15,
      autoAdvance: prefs.getBool(_autoAdvanceKey) ?? false,
      notificationsEnabled: prefs.getBool(_notificationsEnabledKey) ?? true,
      accentColor: Color(prefs.getInt(_accentColorKey) ?? 0xFFFF6464),
    );
  }

  Future<void> saveSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_focusMinutesKey, settings.focusMinutes);
    await prefs.setInt(_shortBreakMinutesKey, settings.shortBreakMinutes);
    await prefs.setInt(_longBreakMinutesKey, settings.longBreakMinutes);
    await prefs.setInt(_customMinutesKey, settings.customMinutes);
    await prefs.setBool(_autoAdvanceKey, settings.autoAdvance);
    await prefs.setBool(_notificationsEnabledKey, settings.notificationsEnabled);
    await prefs.setInt(_accentColorKey, settings.accentColor.value);
  }

  Future<PomodoroState> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    // For simplicity, not saving full state, just settings
    return const PomodoroState();
  }

  Future<void> saveState(PomodoroState state) async {
    // TODO: implement state saving if needed
  }
}