class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Pomodoro Timer',
      'focus': 'Focus',
      'short_break': 'Short Break',
      'long_break': 'Long Break',
      'custom': 'Custom',
      'start': 'Start',
      'pause': 'Pause',
      'resume': 'Resume',
      'reset': 'Reset',
      'next': 'Next',
      'settings': 'Settings',
      'accent_color': 'Accent Color',
      'presets': 'Presets',
      'auto_advance': 'Auto Advance',
      'notifications': 'Notifications',
      'time_remaining': 'Time remaining %d minutes %d seconds',
    },
    'es': {
      'app_title': 'Temporizador Pomodoro',
      'focus': 'Enfoque',
      'short_break': 'Descanso Corto',
      'long_break': 'Descanso Largo',
      'custom': 'Personalizado',
      'start': 'Iniciar',
      'pause': 'Pausar',
      'resume': 'Reanudar',
      'reset': 'Reiniciar',
      'next': 'Siguiente',
      'settings': 'Configuración',
      'accent_color': 'Color de Acento',
      'presets': 'Preajustes',
      'auto_advance': 'Avance Automático',
      'notifications': 'Notificaciones',
      'time_remaining': 'Tiempo restante %d minutos %d segundos',
    },
  };

  final String locale;

  AppLocalizations(this.locale);

  String get appTitle => _localizedValues[locale]?['app_title'] ?? _localizedValues['en']!['app_title']!;
  String get focus => _localizedValues[locale]?['focus'] ?? _localizedValues['en']!['focus']!;
  String get shortBreak => _localizedValues[locale]?['short_break'] ?? _localizedValues['en']!['short_break']!;
  String get longBreak => _localizedValues[locale]?['long_break'] ?? _localizedValues['en']!['long_break']!;
  String get custom => _localizedValues[locale]?['custom'] ?? _localizedValues['en']!['custom']!;
  String get start => _localizedValues[locale]?['start'] ?? _localizedValues['en']!['start']!;
  String get pause => _localizedValues[locale]?['pause'] ?? _localizedValues['en']!['pause']!;
  String get resume => _localizedValues[locale]?['resume'] ?? _localizedValues['en']!['resume']!;
  String get reset => _localizedValues[locale]?['reset'] ?? _localizedValues['en']!['reset']!;
  String get next => _localizedValues[locale]?['next'] ?? _localizedValues['en']!['next']!;
  String get settings => _localizedValues[locale]?['settings'] ?? _localizedValues['en']!['settings']!;
  String get accentColor => _localizedValues[locale]?['accent_color'] ?? _localizedValues['en']!['accent_color']!;
  String get presets => _localizedValues[locale]?['presets'] ?? _localizedValues['en']!['presets']!;
  String get autoAdvance => _localizedValues[locale]?['auto_advance'] ?? _localizedValues['en']!['auto_advance']!;
  String get notifications => _localizedValues[locale]?['notifications'] ?? _localizedValues['en']!['notifications']!;
  String timeRemaining(int minutes, int seconds) {
    final template = _localizedValues[locale]?['time_remaining'] ?? _localizedValues['en']!['time_remaining']!;
    return template.replaceAll('%d', minutes.toString()).replaceAll('%d', seconds.toString());
  }
}