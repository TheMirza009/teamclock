import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';

class NotificationScreen extends ConsumerWidget {
    final timerNotifierProvider = PomodoroStates.timerNotifierProvider;

  void showNotificationWithButtons(WidgetRef ref) {
    final timerValue = ref.watch(timerNotifierProvider);
    AwesomeNotifications().createNotification(
  content: NotificationContent(
    id: 1,
    channelKey: 'high_importance_channel', // Updated to match the initialized channelKey
    title: 'Pomodoro : FOCUS',
    body: '${TimeFunctions.formatTimeFromSeconds(timerValue)}',
  ),
  actionButtons: [
    NotificationActionButton(
      key: 'pause',
      label: 'Pause',
    ),
    NotificationActionButton(
      key: 'reset',
      label: 'Reset',
    ),
    NotificationActionButton(
      key: 'break',
      label: 'Break',
    ),
  ],
);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awesome Notifications Example',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showNotificationWithButtons(ref),
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}
