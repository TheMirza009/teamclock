import 'dart:async';
import 'dart:isolate';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:teamclock/core/base/controllers/notification_controller.dart';
import 'package:teamclock/core/base/controllers/port_controller.dart';
import 'package:teamclock/main.dart';
import 'package:teamclock/root/Data/models/alarm_item.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/homescreen.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/homescreen.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/testscreen.dart';
import 'package:vibration/vibration.dart';
import 'package:timezone/data/latest.dart' as tz;

class AlarmRing {
  const AlarmRing();
  
  static FlutterRingtonePlayer player = FlutterRingtonePlayer();
  static Timer? _vibrationTimer;

  // Stop Alarm Function
  @pragma("vm:entry-point")
  static void stopAlarm(int alarmID) async {
    await AndroidAlarmManager.oneShot(
      Duration.zero,
      alarmID,
      stopAlarmCallback,
      exact: true,
      alarmClock: true,
      wakeup: true,
      allowWhileIdle: true,
    );
  }

  // Stop Ringtone
  @pragma("vm:entry-point")
  static Future<void> stopAlarmCallback(int alarmID) async {
    _vibrationTimer?.cancel();
    await player.stop();
    await Future.wait([
      AndroidAlarmManager.cancel(alarmID),
      AwesomeNotifications().cancel(alarmID),
    ]);
    navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Homescreen(passedIndex: 2)),
            (route) => false, // Remove all previous routes
        );
    // PortMessageController.sendMessage({"id": alarmID});
    }

  // Callback function that prints alarm details
  @pragma('vm:entry-point')
  static void alarmCallback(int id, Map<String, dynamic> params) async {

    // Initializations
    tz.initializeTimeZones();
    PortMessageController.initialize();
    await NotificationController.initializeNotification();
    print("RECEIVED PARAMS IN alarmCallback: $params");

    try {
      // Decode from JSON and trigger Alarm
      AlarmItem alarm = AlarmItem.fromJson(params);
      triggerAlarmIsolate(alarm);
    } catch (e) {
      print('Error decoding alarm data: $e');
    }
  }

  @pragma('vm:entry-point')
  static void triggerAlarmIsolate(AlarmItem alarm) {
    if (alarm.isActive) {
      NotificationController.showAlarmNotification(alarm);
      player.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.glass,
        asAlarm: true,
      );

      // Start Vibration
      if (alarm.vibrateOnRing == true) {
        startVibration();
      }

      // Send data back to the main isolate
      PortMessageController.sendMessage({"id": alarm.id});
    } else {
      print("ALARM ISOLATE: Alarm called but it is not enabled.");
    }
  }

    // Vibration Statr
  static void startVibration() async {
    _vibrationTimer = Timer.periodic(
      const Duration(milliseconds: 1300),
      (timer) async {
        await Vibration.vibrate(
          pattern: [500, 300, 500],
          intensities: [128, 255, 128],
        );
      },
    );
  }

  static void sendTestPortMessage(int id) {
    PortMessageController.sendMessage({"id":id});
  }
}


  // static Future<void> fireNotificationFromID(int id) async {
  //   print("Function called from Alarm Manager");
    
  //   // Initialiations
  //   await Hive.initFlutter();
  //   await Hive.openBox("timezones");
  //   tz.initializeTimeZones();
    
  //   // Read the alarm data from Hive || Decode via Factory method
  //   final alarmsData = await HiveFunctions.readData(key: 5); 
  //   List<dynamic> alarmsList = jsonDecode(alarmsData); 
  //   List<AlarmItem> alarms = alarmsList.map((alarm) => AlarmItem.fromJson(alarm)).toList();
  //   print("Accessed alarmList: $alarms");

  //   // Find the alarm by ID
  //   final alarm = alarms.firstWhere(
  //     (alarm) => alarm.id == id,
  //     orElse: () => AlarmItem.emptyAlarm(), // Handle case where no alarm is found
  //   );

  //   // Notification trigger if found
  //   if (alarm.id != 000) {
  //     print("Found alarm of Timezone: ${alarm.timezone}");
  //     NotificationController.showAlarmNotification(alarm);
  //   } else {
  //     print("Alarm not found with id $id || Empty alarm returned: ${alarm.id}");
  //   }
  // }


  // static void staticTrigger(int id) {
  //   final alarms = AlarmStates.alarmList;
  //   // final alarm = alarms.firstWhere((alarm) => alarm.id == id);
  //   print("LENGTH: ${alarms.length} || ID: $id");
  // }


