import 'package:flutter/material.dart';

import 'core/localization.dart';
import 'core/theme.dart';
import 'features/pomodoro/domain/bootstrap.dart';
import 'features/pomodoro/domain/controller.dart';
import 'features/pomodoro/presentation/pages/home_page.dart';

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key, required this.bootstrap});

  final PomodoroBootstrapResult bootstrap;

  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  late final PomodoroController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.bootstrap.controller;
    widget.bootstrap.lifecycle.attach();
  }

  @override
  void dispose() {
    widget.bootstrap.lifecycle.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final accent = _controller.settings.accentColor;
        return PomodoroScope(
          controller: _controller,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.build(accent),
            localizationsDelegates: AppLocalizations.delegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            home: const HomePage(),
          ),
        );
      },
    );
  }
}
