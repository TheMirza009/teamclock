import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/ViewModel/timezone_functions.dart';

class NotificationScreen extends ConsumerWidget {
  NotificationScreen({super.key});
   
  final timerNotifierProvider = PomodoroStates.timerNotifierProvider;

  void showPomodoroNotification(WidgetRef ref) {
    final timerValue = ref.watch(timerNotifierProvider);
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel', // Updated to match the initialized channelKey
        title: 'Pomodoro',
        body: "Focus timer is running.",
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'play',
          label: 'play',
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

//     AwesomeNotifications(). ((receivedNotification) {
//   if (receivedNotification.actionButtonKey == 'accept') {
//     print('Accepted!');
//   } else if (receivedNotification.actionButtonKey == 'decline') {
//     print('Declined!');
//   }
// });


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awesome Notifications Example',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset("Assets/icons/thunder_sun_72px_green.png"),
            ElevatedButton(
              onPressed: () => showPomodoroNotification(ref),
              child: const Text('Show Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
