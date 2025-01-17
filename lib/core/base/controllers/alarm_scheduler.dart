import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Data/models/weekdays_model.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_ring.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmScheduler {

  // Main function
  static void scheduleAlarm(AlarmItem alarm) {
    if (alarm.repeat == Weekday.none()) {
      _oneShot(alarm);  // One-shot alarm
    } else {
      _schedulePeriodicAlarms(alarm); // Periodic Alarm for days
    }
  }

  // Only Rings once | No repitition
  static void _oneShot(AlarmItem alarm) async {
    await AndroidAlarmManager.oneShotAt(
      alarm.selectedTime,
      alarm.id,
      AlarmRing.alarmCallback,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
    );
  }

  // Rings if other weekdays are selected
  static void _schedulePeriodicAlarms(AlarmItem alarm) {
    final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));

    // Schedule for each day that is true in alarm.repeat
    if (alarm.repeat.monday) {
      _scheduleWeeklyAlarm(alarm, now, 1);
    }
    if (alarm.repeat.tuesday) {
      _scheduleWeeklyAlarm(alarm, now, 2);
    }
    if (alarm.repeat.wednesday) {
      _scheduleWeeklyAlarm(alarm, now, 3);
    }
    if (alarm.repeat.thursday) {
      _scheduleWeeklyAlarm(alarm, now, 4);
    }
    if (alarm.repeat.friday) {
      _scheduleWeeklyAlarm(alarm, now, 5);
    }
    if (alarm.repeat.saturday) {
      _scheduleWeeklyAlarm(alarm, now, 6);
    }
    if (alarm.repeat.sunday) {
      _scheduleWeeklyAlarm(alarm, now, 7);
    }
  }

  // Weekly AndroidAlarmManager function call
  static void _scheduleWeeklyAlarm(AlarmItem alarm, tz.TZDateTime now, int weekday) async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfWeekday(now, weekday, alarm.selectedTime);

    await AndroidAlarmManager.periodic(
      const Duration(days: 7), // Weekly repetition
      alarm.id + weekday, // Unique ID for each weekday alarm
      AlarmRing.alarmCallback,
      startAt: scheduledTime,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
    );
  }

  // Weekday based selected Time
  static tz.TZDateTime _nextInstanceOfWeekday(tz.TZDateTime now, int weekday, tz.TZDateTime selectedTime) {
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    while (scheduledTime.weekday != weekday || scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }
}
