import 'package:flutter/material.dart';

class AppTheme {
  static const Color graphite = Color(0xFF111214);
  static const Color graphiteSurface = Color(0xFF17191B);
  static const Color graphiteOverlay = Color(0xFF1E2022);

  static const List<Color> defaultPalette = <Color>[
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFFF7675),
    Color(0xFF0984E3),
    Color(0xFFFDCB6E),
    Color(0xFF74B9FF),
  ];

  static ThemeData build(Color accent) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      background: graphite,
      surface: graphiteSurface,
    ).copyWith(
      primary: accent,
      secondary: accent,
      surfaceVariant: graphiteOverlay,
    );

    final textTheme = Typography.whiteMountainView.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      decorationColor: accent,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: graphite,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: graphite,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: graphiteSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: graphiteSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: graphiteOverlay,
        contentTextStyle: textTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: graphiteOverlay,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent.withOpacity(0.24)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: graphite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return accent.withOpacity(0.24);
            }
            return graphiteOverlay;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide(color: accent, width: 1.4);
            }
            return BorderSide(color: Colors.white24);
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: Colors.white24,
        thumbColor: accent,
        overlayColor: accent.withOpacity(0.12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: graphiteOverlay,
        selectedColor: accent.withOpacity(0.24),
        disabledColor: Colors.white12,
        labelStyle: textTheme.bodyMedium,
        secondaryLabelStyle: textTheme.bodyMedium,
        side: BorderSide(color: Colors.white12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
