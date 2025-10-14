import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models.dart';

class PomodoroPreferences {
  static const String _keySettings = 'pomodoro_settings';
  static const String _keyState = 'pomodoro_state';

  final SharedPreferences _prefs;

  PomodoroPreferences(this._prefs);

  static Future<PomodoroPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PomodoroPreferences(prefs);
  }

  // Settings
  Future<void> saveSettings(PomodoroSettings settings) async {
    final json = jsonEncode(settings.toJson());
    await _prefs.setString(_keySettings, json);
  }

  PomodoroSettings loadSettings() {
    final json = _prefs.getString(_keySettings);
    if (json == null) {
      return const PomodoroSettings();
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PomodoroSettings.fromJson(map);
    } catch (e) {
      return const PomodoroSettings();
    }
  }

  // State
  Future<void> saveState(PomodoroState state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString(_keyState, json);
  }

  PomodoroState loadState() {
    final json = _prefs.getString(_keyState);
    if (json == null) {
      return const PomodoroState();
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PomodoroState.fromJson(map);
    } catch (e) {
      return const PomodoroState();
    }
  }

  Future<void> clearState() async {
    await _prefs.remove(_keyState);
  }
}
