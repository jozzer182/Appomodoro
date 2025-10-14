import 'package:flutter/material.dart';

import 'controller.dart';

typedef PomodoroLifecycleHandle = void Function(AppLifecycleState state);

class PomodoroLifecycle {
  PomodoroLifecycle({required this.handle});

  final PomodoroLifecycleHandle handle;

  void attach() {}

  void detach() {}
}

class PomodoroBootstrapResult {
  const PomodoroBootstrapResult({
    required this.controller,
    required this.lifecycle,
  });

  final PomodoroController controller;
  final PomodoroLifecycle lifecycle;
}

class PomodoroBootstrap {
  static Future<PomodoroBootstrapResult> initialize() {
    throw UnimplementedError('Bootstrap not implemented yet');
  }
}
