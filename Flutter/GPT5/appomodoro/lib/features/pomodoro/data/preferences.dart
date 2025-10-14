import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _accentKey = 'accent';
  static const _autoAdvanceKey = 'autoAdvance';
  static const _focusKey = 'focusMin';
  static const _shortKey = 'shortMin';
  static const _longKey = 'longMin';
  static const _sessionPrefix = 'session_';

  final SharedPreferences prefs;
  Prefs(this.prefs);

  Future<void> setAccent(Color c) async {
    await prefs.setInt(_accentKey, c.value);
  }

  Color get accent =>
      Color(prefs.getInt(_accentKey) ?? const Color(0xFF5AC8FA).value);

  Future<void> setAutoAdvance(bool v) async =>
      prefs.setBool(_autoAdvanceKey, v);
  bool get autoAdvance => prefs.getBool(_autoAdvanceKey) ?? true;

  Future<void> setDurations({
    required int focusMin,
    required int shortMin,
    required int longMin,
  }) async {
    await prefs.setInt(_focusKey, focusMin);
    await prefs.setInt(_shortKey, shortMin);
    await prefs.setInt(_longKey, longMin);
  }

  (int, int, int) get durations => (
    prefs.getInt(_focusKey) ?? 25,
    prefs.getInt(_shortKey) ?? 5,
    prefs.getInt(_longKey) ?? 15,
  );

  Future<void> saveSession({
    required String phase,
    required int targetSeconds,
    required int startedAtMillis,
    required int accumulatedPauseMillis,
    required bool running,
  }) async {
    await prefs.setString(
      '$_sessionPrefix'
      'phase',
      phase,
    );
    await prefs.setInt(
      '$_sessionPrefix'
      'target',
      targetSeconds,
    );
    await prefs.setInt(
      '$_sessionPrefix'
      'startedAt',
      startedAtMillis,
    );
    await prefs.setInt(
      '$_sessionPrefix'
      'accPause',
      accumulatedPauseMillis,
    );
    await prefs.setBool(
      '$_sessionPrefix'
      'running',
      running,
    );
  }

  Map<String, Object?>? loadSession() {
    final phase = prefs.getString(
      '$_sessionPrefix'
      'phase',
    );
    final target = prefs.getInt(
      '$_sessionPrefix'
      'target',
    );
    final startedAt = prefs.getInt(
      '$_sessionPrefix'
      'startedAt',
    );
    final acc = prefs.getInt(
      '$_sessionPrefix'
      'accPause',
    );
    final running = prefs.getBool(
      '$_sessionPrefix'
      'running',
    );
    if (phase == null ||
        target == null ||
        startedAt == null ||
        acc == null ||
        running == null)
      return null;
    return {
      'phase': phase,
      'target': target,
      'startedAt': startedAt,
      'accPause': acc,
      'running': running,
    };
  }
}
