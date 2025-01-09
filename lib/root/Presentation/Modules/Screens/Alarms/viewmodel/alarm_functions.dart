import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/view/alarm_add_alarm_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/core/base/controllers/notification_controller.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Data/models/ringtone_model.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/view/alarm_list_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class AlarmFunctions {
  
  // Declarations
  static final AudioPlayer player = AudioPlayer();
   static Timer? _vibrationTimer;

  // Stop Alarm
  static Future<void> stopAlarm(WidgetRef ref, AlarmItem alarm) async {
    await player.stop();
    await Vibration.cancel();
    _vibrationTimer?.cancel();
    alarm.isRinging = false;
    // Future.delayed(const Duration(milliseconds: 300));
    if (alarm.deleteAfterRing) removeAlarm(ref, alarm);
    AwesomeNotifications().cancel(10);
  }

  // Play sound
  static Future<void> playAlarmSound(WidgetRef ref, AlarmItem alarm) async {
    try {
      await player.setAsset(alarm.ringtone.path);
      player.setLoopMode(alarm.ringtone.loop);
      await player.play();
      print("ALARM RANG ONCE AND WILL NOW BE REMOVED ========================================================= ");
      stopAlarm(ref, alarm);
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  // Remove Alarm Function using AlarmItem directly
  static void removeAlarm(WidgetRef ref, AlarmItem alarm) async {
    // Access the alarms from the provider
    final alarms = ref.read(AlarmStates.alarmsProvider);

    // Stop the alarm sound if it's ringing
    if (alarm.isRinging) {
      alarm.isRinging = false; // Stop the ringing state
      AlarmFunctions.stopAlarm(ref, alarm); // Stop the sound
    }

    // Remove the alarm from the list
    alarms.removeWhere((existingAlarm) => existingAlarm.id == alarm.id);

    // Update the provider and save the updated list
    ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms);
    HiveFunctions.saveAlarmList(alarms);
  }

  // Clear Alarms
  static Future<void> clearAlarms(WidgetRef ref) async {
    final alarms = ref.read(
        AlarmStates.alarmsProvider); // Access the alarms from the provider

    // Ensure that at least one alarm exists before trying to clear others
    if (alarms.isNotEmpty) {
      alarms.clear();

      // Update the provider and save the updated list
      ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms);
      await HiveFunctions.saveAlarmList(alarms);
    }
  }

  // FIRE ALARM FUNCTION
  static Future<void> fireAlarm(WidgetRef ref, AlarmItem alarm) async {
    alarm.isRinging = true;
    NotificationController.showAlarmNotification(alarm);
    AlarmFunctions.playAlarmSound(ref, alarm);
    if (alarm.vibrateOnRing) {
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
  }

  // Time difference function
  static String calculateTimeDifference(
  String selectedTimezone, 
  TZDateTime alarmSelectedTime,
  bool show12hourformat, // New parameter
) {
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

  // Determine whether to use 12-hour or 24-hour format
  if (show12hourformat) {
    final amPm = hours >= 12 ? 'PM' : 'AM';
    final hourIn12HourFormat = hours % 12 == 0 ? 12 : hours % 12;
    return "$hours hours and $minutes minutes remain";
  } else {
    // Return the time in 24-hour format
    return "$hours hours and $minutes minutes remain";
  }
}



  // Main Alarm Function
static void triggerAlarms(WidgetRef ref) async {
  final alarms = ref.read(AlarmStates.alarmsProvider); // Read alarms

  for (final alarm in alarms) {
    // final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));

    // Check if the alarm should ring
    if (!alarm.isRinging &&
        // alarm.selectedTime.hour == now.hour &&
        // alarm.selectedTime.minute == now.minute &&
        // alarm.selectedTime.second == now.second &&
        alarm.isActive) {
      await fireAlarm(ref, alarm);
    }
  }

  // Trigger UI rebuild
  ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms);
}

  // Add Alarm Function
  static Future<void> addAlarm(BuildContext context, WidgetRef ref) async {
    print((DateTime.now().hour % 12));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddAlarmScreen(
          onAlarmAdded: (AlarmItem alarm) async {
            ref.read(AlarmStates.alarmsProvider.notifier).state = [
              ...ref.read(AlarmStates.alarmsProvider),
              AlarmItem(
                id: alarm.id,
                title: alarm.title,
                timezone: alarm.timezone,
                selectedTime: alarm.selectedTime,
                ringtone: alarm.ringtone,
                deleteAfterRing: alarm.deleteAfterRing,
                vibrateOnRing: alarm.vibrateOnRing,
              ),
            ];
            print("PARSED TIME : ${tz.TZDateTime.parse(tz.getLocation(alarm.timezone), alarm.selectedTime.toString())}");
            final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
            HiveFunctions.saveAlarmList(alarmList);
          },
        );
      },
    );
  }

  // Add Alarm Function
  static Future<void> editAlarm(BuildContext context, WidgetRef ref, AlarmItem existingAlarm) async {
    print((DateTime.now().hour % 12));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddAlarmScreen(
          existingAlarm: existingAlarm,
          onAlarmAdded: (AlarmItem newAlarm) async {

            // REPLACE ALARM LOGIC
            ref.read(AlarmStates.alarmsProvider.notifier).update((alarms) {
              final index = alarms.indexWhere((alarm) => alarm.id == existingAlarm.id);
              if (index != -1) { alarms[index] = newAlarm; }
              return List.of(alarms); // Return a new list for state update
            });

            final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
            HiveFunctions.saveAlarmList(alarmList);
          },
        );
      },
    );
  }

  // External Replace Alarm Function
  // call => replaceAlarm(ref, existingAlarm.id, newAlarm);
  static void replaceAlarm(WidgetRef ref, int existingAlarmID, AlarmItem newAlarm) {
    ref.read(AlarmStates.alarmsProvider.notifier).update((alarms) {
      final index = alarms.indexWhere((alarm) => alarm.id == existingAlarmID);
      if (index != -1) {
        alarms[index] = newAlarm;
      }
      return List.of(alarms); // Return a new list for state update
    });
  }


  static Future<void> vibrateOnRing() async {
    // Check if the device can vibrate
    bool? canVibrate = await Vibration.hasVibrator();

    if (canVibrate == true) {
      Vibration.vibrate(pattern: [500, 300, 500], intensities: [128, 255, 128]);
    } else {
      print("Device does not support vibration.");
    }
  }
}
