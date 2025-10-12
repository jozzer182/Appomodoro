import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

const accentColor = Color(0xFFFF6464);
const darkGraphite = Color(0xFF1C1D21);
const lightGraphite = Color(0xFFF5F5F7);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightGraphite,
  scaffoldBackgroundColor: lightGraphite,
  colorScheme: const ColorScheme.light(
    primary: accentColor,
    secondary: accentColor,
    surface: lightGraphite,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  appBarTheme: const AppBarTheme(
    backgroundColor: lightGraphite,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkGraphite,
  scaffoldBackgroundColor: darkGraphite,
  colorScheme: const ColorScheme.dark(
    primary: accentColor,
    secondary: accentColor,
    surface: Color(0xFF2A2B2F),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
   appBarTheme: const AppBarTheme(
    backgroundColor: darkGraphite,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
  ),
);
