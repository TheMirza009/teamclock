import 'dart:async';
import 'package:vibration/vibration.dart';
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
   static Timer? _vibrationTimer;


  // Stop Alarm
  static void stopAlarm(WidgetRef ref, AlarmItem alarm) async {
    await player.stop();
    await Vibration.cancel();
    _vibrationTimer?.cancel();
    alarm.isRinging = false;
    Future.delayed(const Duration(milliseconds: 300));
    if (alarm.deleteAfterRing) removeAlarm(ref, alarm);
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

  static Future<void> fireAlarm(WidgetRef ref, AlarmItem alarm) async {
    alarm.isRinging = true;
    NotificationController.showAlarmNotification();
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
      await fireAlarm(ref, alarm);
    }
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
          onTimezoneAdded: (AlarmItem alarm) async {
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
            final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
            HiveFunctions.saveAlarmList(alarmList);
          },
        );
      },
    );
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
