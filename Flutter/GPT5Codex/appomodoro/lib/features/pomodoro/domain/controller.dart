import 'package:flutter/material.dart';

class PomodoroController extends ChangeNotifier {
  PomodoroSettings get settings => throw UnimplementedError();
}

class PomodoroSettings {
  const PomodoroSettings({required this.accentColor});

  final Color accentColor;
}

class PomodoroScope extends InheritedNotifier<PomodoroController> {
  const PomodoroScope({
    super.key,
    required PomodoroController controller,
    required super.child,
  }) : super(notifier: controller);

  static PomodoroController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PomodoroScope>();
    if (scope == null) {
      throw FlutterError('PomodoroScope.of() called with no PomodoroScope in context');
    }
    return scope.notifier!;
  }

  @override
  bool updateShouldNotify(PomodoroScope oldWidget) => notifier != oldWidget.notifier;
}
