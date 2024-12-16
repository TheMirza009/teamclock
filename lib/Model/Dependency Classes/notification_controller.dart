import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_test_screen.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
import 'package:time_slider/main.dart';

class NotificationController {
  static Future<void> initializeNotification() async {
    // Initialize the notification system
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
        ),
      ],
      debug: true,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  // @pragma("vm:entry-point")
  // static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  //   // Your code goes here

  //   // Navigate into pages, avoiding to open the notification details page over another details page already opened
  //   MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
  //           (route) => (route.settings.name != '/notification-page') || route.isFirst,
  //       arguments: receivedAction);
  // }

  // POMODORO NOTIFICATIONS

  static void showPomodoroNotificationOnStart(WidgetRef ref) {
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
          key: 'pause',
          label: 'pause',
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

  static void showPomodoroNotificationOnEnd() {
    print("Triggering Pomodoro end notification...");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel', // Updated to match the initialized channelKey
        title: 'Pomodoro',
        body: "Focus complete!",
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'reset',
          label: 'Reset',
        ),
        NotificationActionButton(
          key: 'break',
          label: 'Short Break',
        ),
        NotificationActionButton(
          key: 'longbreak',
          label: 'Long Break',
        ),
      ],
    );
  }

  static void showAlarmNotification() {
    print("Triggering Alarm...");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel', // Updated to match the initialized channelKey
        title: 'Alarm',
        body: "Currently ringing!",
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'stopalarm',
          label: 'Stop Alarm',
        ),
      ],
    );
  }

  static void fireScheduledNotification(DateTime selectedTime) {
    print("Scheduling Alarm for $selectedTime...");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel',
        title: 'Alarm',
        body: "Currently ringing!",
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        year: selectedTime.year,
        month: selectedTime.month,
        day: selectedTime.day,
        hour: selectedTime.hour,
        minute: selectedTime.minute,
        second: 0,
        millisecond: 0,
        repeats: false, // Set to true if the alarm is recurring
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'stopalarm',
          label: 'Stop Alarm',
          autoDismissible: true,
        ),
      ],
    );
  }


  static void setListeners(WidgetRef ref) {
    final timerNotifierProvider = PomodoroStates.timerNotifierProvider;

    pomodoroBreak({required WidgetRef ref, required int index}) {
      ref.read(timerNotifierProvider.notifier).pause();
      ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
      ref.read(PomodoroStates.segmentedControlValue.notifier).state = index;
      ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetAllTimers();
      Future.delayed(
        const Duration(milliseconds: 200), // Delay for 200 milliseconds
        () {
          ref.read(timerNotifierProvider.notifier).play();
          ref.read(PomodoroStates.isPlayingProvider.notifier).state = true;
        }, // Function to execute
      );
    }

    // Set up notification listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) async {
        if (receivedAction.buttonKeyPressed == "pause") {
          print(receivedAction.title);
          ref.read(timerNotifierProvider.notifier).pause();
        }

        if (receivedAction.buttonKeyPressed == "reset") {
          print(receivedAction.title);
          ref.read(timerNotifierProvider.notifier).pause();
          ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetAllTimers();
          ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
        }

        if (receivedAction.buttonKeyPressed == "break") {
          print(receivedAction.title);
          pomodoroBreak(ref: ref, index: 1);
          ref.read(timerNotifierProvider.notifier).reset();
        }

        if (receivedAction.buttonKeyPressed == "longbreak") {
          print(receivedAction.title);
          pomodoroBreak(ref: ref, index: 2);
          ref.read(timerNotifierProvider.notifier).reset();
        }

        if (receivedAction.buttonKeyPressed == "stopalarm") {
          final alarms = ref.watch(alarmsProvider);
          print(receivedAction.title);
          AlarmFunctions.stopAlarm(alarms[0], ref);
        }
      },
    );
  }
}
