import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> delegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    DefaultWidgetsLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  String get appTitle => 'Appomodoro';
  String get focus => 'Focus';
  String get shortBreak => 'Short Break';
  String get longBreak => 'Long Break';
  String get custom => 'Custom';
  String get start => 'Start';
  String get pause => 'Pause';
  String get resume => 'Resume';
  String get reset => 'Reset';
  String get next => 'Next';
  String get autoAdvance => 'Auto advance';
  String get notifications => 'Notifications';
  String get accentColor => 'Accent color';
  String get presets => 'Presets';
  String get focusDuration => 'Focus duration';
  String get shortBreakDuration => 'Short break';
  String get longBreakDuration => 'Long break';
  String get cyclesUntilLongBreak => 'Cycles until long break';
  String get settings => 'Settings';
  String get close => 'Close';
  String get save => 'Save';
  String get timeRemainingLabel => 'Time remaining';
  String minutesAndSeconds(int minutes, int seconds) => '$minutes minutes $seconds seconds';
  String get notifyOnComplete => 'Notify when phase completes';
  String get enableVibration => 'Vibrate on Android';
  String get customDuration => 'Custom duration';
  String get apply => 'Apply';
  String get cancel => 'Cancel';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
