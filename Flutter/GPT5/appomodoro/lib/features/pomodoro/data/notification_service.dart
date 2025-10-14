import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'pomodoro_phase',
    'Phase Notifications',
    description: 'Notifies when a Pomodoro phase ends',
    importance: Importance.defaultImportance,
  );

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _fln.initialize(
      const InitializationSettings(android: android, iOS: iOS),
    );
    try {
      // Android channel
      await _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    } catch (_) {}
  }

  static Future<void> showPhaseEnd(String title, String body) async {
    final android = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
    );
    const iOS = DarwinNotificationDetails();
    final details = NotificationDetails(android: android, iOS: iOS);
    try {
      await _fln.show(1, title, body, details);
    } catch (_) {}
  }
}
