import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appomodoro/core/theme.dart';
import 'package:appomodoro/features/pomodoro/presentation/pages/home_page.dart';

class Appomodoro extends ConsumerWidget {
  const Appomodoro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Appomodoro',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
