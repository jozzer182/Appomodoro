import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/pomodoro/presentation/pages/home_page.dart';
import 'features/pomodoro/data/notification_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appomodoro',
      theme: buildNeutralTheme(),
      home: const HomePage(),
    );
  }
}
