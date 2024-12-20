import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_list_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class AlarmFunctions {
  static final AudioPlayer player = AudioPlayer();

  static void stopAlarm(AlarmItem alarmItem, WidgetRef ref) async {
    await player.stop();
    alarmItem.isRinging = false;
  }

  static Future<void> playAlarmSound(String path) async {
    try {
      await player.setAsset(path);
      player.setLoopMode(LoopMode.one);
      await player.play();
    } catch (e) {
      print('Error playing alarm sound: $e');
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
}
