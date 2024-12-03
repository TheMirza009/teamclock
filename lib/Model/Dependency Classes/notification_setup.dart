import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationSetup {
  static Future<void> initializeNotification() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Test Channel',
          channelDescription: 'Testing notifications for template app.',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        )
      ],
      debug: true,
    );
  }
}
