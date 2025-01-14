import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:time_slider/core/base/controllers/notification_controller.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:vibration/vibration.dart';
import 'package:timezone/data/latest.dart' as tz;

class AlarmRing {
  const AlarmRing();
  
  static FlutterRingtonePlayer player = FlutterRingtonePlayer();
  static Timer? _vibrationTimer;

  // Stop Alarm Function
  @pragma("vm:entry-point")
  void stopAlarm() async {
    await AndroidAlarmManager.oneShot(
      Duration.zero,
      10, //This ID has to be the same as above
      stopAlarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  // Stop Ringtone
  static Future<void> stopAlarmCallback() async {
    final alarms = AlarmStates.alarmList;
    _vibrationTimer?.cancel();
    await player.stop();
    alarms.forEach((alarm) async => await AndroidAlarmManager.cancel(alarm.id));
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

  // Callback function that prints alarm details
  static void printAlarmDetails(int id, Map<String, dynamic> params) async {

    // Initializations
    tz.initializeTimeZones();
    await NotificationController.initializeNotification();

    // try-catch
    try {
      // Decode JSON into AlarmItem
      AlarmItem alarm = AlarmItem.fromJson(params);
      NotificationController.showAlarmNotification(alarm);
      player.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.glass,
        asAlarm: true,
      );

      // Start Vibration
      if (alarm.vibrateOnRing) {
        startVibration();
      }

      // Print the alarm details
      print('Alarm triggered (ID: $id):');
      print('Title: ${alarm.title}');
      print('Timezone: ${alarm.timezone}');
      print('Selected Time: ${alarm.selectedTime}');
    } catch (e) {
      print('Error decoding alarm data: $e');
    }
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


