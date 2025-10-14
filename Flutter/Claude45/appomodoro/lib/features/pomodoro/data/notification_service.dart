import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../domain/models.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notifications.initialize(initSettings);
      
      // Create Android notification channel
      const androidChannel = AndroidNotificationChannel(
        'pomodoro_channel',
        'Pomodoro Notifications',
        description: 'Notifications for Pomodoro timer phases',
        importance: Importance.high,
        playSound: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      _initialized = true;
    } catch (e) {
      // Silently fail - notifications are optional
      print('Notification initialization failed: $e');
    }
  }

  Future<void> showPhaseCompleteNotification(PomodoroPhase phase) async {
    if (!_initialized) return;

    final title = _getNotificationTitle(phase);
    final body = _getNotificationBody(phase);

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Notifications',
      channelDescription: 'Notifications for Pomodoro timer phases',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        0,
        title,
        body,
        details,
      );
    } catch (e) {
      // Silently fail
      print('Failed to show notification: $e');
    }
  }

  String _getNotificationTitle(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'Focus Complete!';
      case PomodoroPhase.shortBreak:
        return 'Break Complete!';
      case PomodoroPhase.longBreak:
        return 'Long Break Complete!';
      case PomodoroPhase.custom:
        return 'Timer Complete!';
    }
  }

  String _getNotificationBody(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'Great work! Time for a break.';
      case PomodoroPhase.shortBreak:
        return 'Break over. Ready to focus?';
      case PomodoroPhase.longBreak:
        return 'Long break complete. Start a new session?';
      case PomodoroPhase.custom:
        return 'Custom timer finished!';
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e) {
      // Silently fail
      print('Failed to request permissions: $e');
    }
  }
}
