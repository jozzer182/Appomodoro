import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/pomodoro/data/notification_service.dart';
import 'features/pomodoro/data/preferences.dart';
import 'features/pomodoro/domain/engine.dart';
import 'features/pomodoro/domain/models.dart';
import 'features/pomodoro/presentation/pages/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late PomodoroEngine _engine;
  late PomodoroPreferences _preferences;
  late NotificationService _notificationService;
  Color _accentColor = AppTheme.defaultAccent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize preferences
    _preferences = await PomodoroPreferences.create();
    
    // Load saved settings and state
    final savedSettings = _preferences.loadSettings();
    final savedState = _preferences.loadState();

    // Initialize engine
    _engine = PomodoroEngine(
      settings: savedSettings,
      state: savedState,
    );

    _engine.addListener(_onEngineChanged);

    // Initialize notifications
    _notificationService = NotificationService();
    await _notificationService.initialize();
    await _notificationService.requestPermissions();

    setState(() {
      _accentColor = Color(savedSettings.accentColorValue);
    });
  }

  void _onEngineChanged() {
    // Save state and settings when they change
    _preferences.saveSettings(_engine.settings);
    _preferences.saveState(_engine.state);

    // Update accent color if changed
    final newAccentColor = Color(_engine.settings.accentColorValue);
    if (_accentColor != newAccentColor) {
      setState(() {
        _accentColor = newAccentColor;
      });
    }
  }

  void _onPhaseComplete(PomodoroPhase phase) {
    if (_engine.settings.notificationsEnabled) {
      _notificationService.showPhaseCompleteNotification(phase);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _engine.removeListener(_onEngineChanged);
    _engine.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Save state when app goes to background
      _preferences.saveSettings(_engine.settings);
      _preferences.saveState(_engine.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appomodoro',
      theme: AppTheme.buildTheme(_accentColor),
      debugShowCheckedModeBanner: false,
      home: HomePage(
        engine: _engine,
        onPhaseComplete: _onPhaseComplete,
      ),
    );
  }
}
