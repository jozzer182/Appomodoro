import 'package:flutter/material.dart';

ThemeData buildNeutralTheme({Color accent = const Color(0xFF5AC8FA)}) {
  final base = ThemeData.dark(useMaterial3: true);
  final scheme = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: Brightness.dark,
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF111214),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    dividerColor: const Color(0x22FFFFFF),
    splashFactory: InkRipple.splashFactory,
  );
}
