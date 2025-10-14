import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'features/pomodoro/domain/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bootstrap = await PomodoroBootstrap.initialize();
  runApp(PomodoroApp(bootstrap: bootstrap));
}
