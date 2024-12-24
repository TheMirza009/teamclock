import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/Model/Models/ringtone_model.dart';
import 'package:time_slider/Model/alarm_states.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_list_screen.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_alarm_screen_add_alarm.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class AlarmFunctions {

  // Declarations
  static final AudioPlayer player = AudioPlayer();

  // Stop Alarm
  static void stopAlarm(AlarmItem alarm) async {
    await player.stop();
    alarm.isRinging = false;
  }

  // Play sound
  static Future<void> playAlarmSound(AlarmItem alarm) async {
    try {
      await player.setAsset(alarm.ringtone.path);
      player.setLoopMode(alarm.ringtone.loop);
      await player.play();
      print("ALARM RANG ONCE AND WILL NOW BE REMOVED ========================================================= ");
      stopAlarm(alarm);
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  static Future<void> fireAlarm(AlarmItem alarm) async {
    alarm.isRinging = true;
    NotificationController.showAlarmNotification();
    AlarmFunctions.playAlarmSound(alarm);
  }

  // Time difference function
  static String calculateTimeDifference( String selectedTimezone, TZDateTime alarmSelectedTime) {
    final deviceTime = DateTime.now();  // Get the current device time in UTC

    // Convert the current device time to the selected timezone
    final currentTimeInSelectedTimezone = tz.TZDateTime.from(deviceTime, tz.getLocation(selectedTimezone));

    // Convert the alarmSelectedTime to the selected timezone
    final alarmTimeInSelectedTimezone = tz.TZDateTime(
      tz.getLocation(selectedTimezone),
      currentTimeInSelectedTimezone.year,
      currentTimeInSelectedTimezone.month,
      currentTimeInSelectedTimezone.day,
      alarmSelectedTime.hour,
      alarmSelectedTime.minute,
    );

    // If the alarm time is earlier than the current time, move it to the next day
    var adjustedAlarmTime = alarmTimeInSelectedTimezone;
    if (alarmTimeInSelectedTimezone.isBefore(currentTimeInSelectedTimezone)) {
      adjustedAlarmTime = alarmTimeInSelectedTimezone.add(const Duration(days: 1));
    }

    // Calculate the difference between the adjusted alarm time and current time
    final difference = adjustedAlarmTime.difference(currentTimeInSelectedTimezone);

    // Check if the time remaining is less than a minute
    if (difference.inSeconds < 60 && difference.inSeconds > 0) {
      return "${difference.inSeconds} seconds remain";
    }

    if (difference.inSeconds == 0 && difference.inMinutes == 0 ) return "Alarm Ringing!";

    // Extract hours and minutes
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    // Return the appropriate string
    return "$hours hours and $minutes minutes remain";
  }

  // // Main Alarm Function
  // static void triggerAlarms(Timer timer, WidgetRef ref) {
  //   final alarms = ref.read(AlarmStates.alarmsProvider); // Read alarms

  //   for (final alarm in alarms) {
  //     final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));
  //     if (!alarm.isRinging &&
  //         alarm.selectedTime.hour == now.hour &&
  //         alarm.selectedTime.minute == now.minute &&
  //         alarm.selectedTime.second == now.second &&
  //         alarm.isActive == true) {
  //       alarm.isRinging = true;
  //       NotificationController.showAlarmNotification();
  //       AlarmFunctions.playAlarmSound(path: alarm.ringtone.path, loopMode: alarm.ringtone.loop);

  //       if (alarm.deleteAfterRing == true) AlarmFunctions.removeAlarm(ref, alarms, 0);

  //     }
  //   }
  //   ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms); // Trigger UI update
  // }

  // Main Alarm Function
static void triggerAlarms(Timer timer, WidgetRef ref) async {
  final alarms = ref.read(AlarmStates.alarmsProvider); // Read alarms

  for (final alarm in alarms) {
    final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));

    // Check if the alarm should ring
    if (!alarm.isRinging &&
        alarm.selectedTime.hour == now.hour &&
        alarm.selectedTime.minute == now.minute &&
        alarm.selectedTime.second == now.second &&
        alarm.isActive) {
      await fireAlarm(alarm);
      // if (alarm.deleteAfterRing == true) {
      //   AlarmFunctions.removeAlarm(ref, alarms, alarms.indexOf(alarm));
      //   print("ALARM RANG ONCE AND WILL NOW BE REMOVED");  
      // };
    }



    // // If the alarm is ringing, check if it should stop
    // if (alarm.isRinging && alarm.ringtone.loop == LoopMode.off) {
    //   // The alarm should automatically stop after ringing
    //   // If the alarm hasn't stopped on its own, we can stop it here
    //   // alarm.isRinging = false; // Mark as not ringing
    //   // AlarmFunctions.stopAlarm(alarm); // Stop the sound if it hasn't stopped automatically
    //   // Check if the alarm should be deleted after ringing
    //   if (alarm.deleteAfterRing) {
    //     AlarmFunctions.removeAlarm(ref, alarms, alarms.indexOf(alarm)); // Remove the alarm after stopping
    //   }
    // }
  }

  // Trigger UI update
  ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms);
}


  // Add Alarm Function
  static Future<void> addAlarm(BuildContext context, WidgetRef ref) async {
    print((DateTime.now().hour % 12));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddAlarmScreen(
          onTimezoneAdded: ( String alarmTitle, String timezone, tz.TZDateTime selectedTime, Ringtone ringtone, bool deleteAfterRing ) async {
            ref.read(AlarmStates.alarmsProvider.notifier).state = [
              ...ref.read(AlarmStates.alarmsProvider),
              AlarmItem(
                id: DateTime.now().microsecondsSinceEpoch,
                title: alarmTitle,
                timezone: timezone,
                selectedTime: selectedTime,
                ringtone: ringtone,
                deleteAfterRing: deleteAfterRing
              ),
            ];
            final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
            HiveFunctions.saveAlarmList(alarmList);
          },
        );
      },
    );
  }

  // Remove Alarm Function
  static void removeAlarm(WidgetRef ref, List<AlarmItem> alarms, int index,) {

    // Stop the alarm sound if it's ringing
    if (alarms[index].isRinging) {
      alarms[index].isRinging = false; // Stop the ringing state
      AlarmFunctions.stopAlarm(alarms[index]); // Add a function to stop the sound
    }

    // Remove the alarm from the list and update the provider
    alarms.removeAt(index);
    ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms);

    // Save the updated alarm list to Hive
    final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
    HiveFunctions.saveAlarmList(alarmList);
  }
}
