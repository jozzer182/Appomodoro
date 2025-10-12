import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'features/pomodoro/domain/engine.dart';
import 'features/pomodoro/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroEngine(),
      child: Consumer<PomodoroEngine>(
        builder: (context, engine, child) {
          return MaterialApp(
            title: 'Pomodoro Timer',
            theme: AppTheme.darkTheme(engine.settings.accentColor),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}