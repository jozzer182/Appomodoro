import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'models.dart';
import '../data/notification_service.dart';

class PomodoroEngine extends ChangeNotifier with WidgetsBindingObserver {
  PomodoroEngine({Presets? presets}) : presets = presets ?? const Presets();

  final Presets presets;
  final Stopwatch _stopwatch = Stopwatch();
  Ticker? _ticker;
  Phase _phase = Phase.focus;
  int _focusCount = 0;
  Duration _target = const Duration(minutes: 25);
  Duration _accumulatedPause = Duration.zero;
  DateTime? _startedAt;
  bool _running = false;

  Phase get phase => _phase;
  int get focusCount => _focusCount;
  bool get isRunning => _running;
  Duration get target => _target;

  // elapsed seconds as double using monotonic time
  double get elapsedSec {
    if (_startedAt == null) return 0;
    final now = DateTime.now();
    final elapsed = now.difference(_startedAt!);
    final effective = elapsed - _accumulatedPause;
    return max(0, effective.inMilliseconds / 1000.0);
  }

  Duration get remaining {
    final rem = _target - Duration(milliseconds: (elapsedSec * 1000).toInt());
    return rem.isNegative ? Duration.zero : rem;
  }

  void init() {
    _setPhase(Phase.focus);
    _ticker ??= Ticker(_onTick)..start();
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeEngine() {
    _ticker?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTick(Duration _) {
    if (_running && remaining == Duration.zero) {
      _onPhaseEnd();
    }
    notifyListeners(); // drive 60fps UI
  }

  void _onPhaseEnd() {
    _running = false;
    // Notify
    NotificationService.showPhaseEnd('Phase complete', 'Time to switch');
    // auto-advance
    if (presets.autoAdvance) {
      nextPhase();
      start();
    } else {
      notifyListeners();
    }
  }

  void start() {
    if (_running) return;
    _running = true;
    _startedAt = DateTime.now();
    _accumulatedPause = Duration.zero;
    _stopwatch.reset();
    _stopwatch.start();
    notifyListeners();
  }

  void pause() {
    if (!_running) return;
    _running = false;
    _stopwatch.stop();
    notifyListeners();
  }

  void resume() {
    if (_running || _startedAt == null) return;
    _running = true;
    _accumulatedPause += _stopwatch.elapsed;
    _stopwatch
      ..reset()
      ..start();
    notifyListeners();
  }

  void reset() {
    _running = false;
    _startedAt = null;
    _stopwatch.reset();
    _accumulatedPause = Duration.zero;
    notifyListeners();
  }

  void nextPhase() {
    switch (_phase) {
      case Phase.focus:
        _focusCount++;
        _setPhase(_focusCount % 4 == 0 ? Phase.longBreak : Phase.shortBreak);
        break;
      case Phase.shortBreak:
      case Phase.longBreak:
        _setPhase(Phase.focus);
        break;
      case Phase.custom:
        _setPhase(Phase.focus);
        break;
    }
  }

  void setCustom(Duration d) {
    _target = d;
    _phase = Phase.custom;
    reset();
  }

  void _setPhase(Phase p) {
    _phase = p;
    switch (p) {
      case Phase.focus:
        _target = presets.focus;
        break;
      case Phase.shortBreak:
        _target = presets.shortBreak;
        break;
      case Phase.longBreak:
        _target = presets.longBreak;
        break;
      case Phase.custom:
        _target = presets.custom;
        break;
    }
    reset();
  }

  void setPhase(Phase p) => _setPhase(p);

  // Angles per spec
  double get thetaS {
    final es = elapsedSec % 60.0;
    return -pi / 2 + 2 * pi * (es / 60.0);
  }

  double get thetaM {
    final em = elapsedSec / 60.0;
    return -pi / 2 + 2 * pi * ((em) / 60.0);
  }
}
