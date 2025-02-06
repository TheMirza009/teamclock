import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:teamclock/root/Data/models/alarm_item.dart';
import 'package:teamclock/root/Data/models/weekdays_model.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_ring.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmScheduler {

  // Main function
  @pragma("vm:entry-point")
  static Future<void> scheduleAlarm(AlarmItem alarm) async {
    print("ALARM SCHEDULED for: ${alarm.id}");
    if (alarm.repeat == Weekday.none()) {
      print("Alarm: ONE-SHOT "); // Single shot if no repition
      await _oneShot(alarm);
    } else {
      print("Alarm: PERIODIC");
      _schedulePeriodicAlarms(alarm); // Periodic Alarm for days
    }
  }

  // Only Rings once | No repitition
  @pragma("vm:entry-point")
  static Future<void> _oneShot(AlarmItem alarm) async {
    await AndroidAlarmManager.oneShotAt(
      alarm.selectedTime,
      alarm.id,
      AlarmRing.alarmCallback,
      params: alarm.toJson(),
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
    );
  }

  // Rings if other weekdays are selected
  @pragma("vm:entry-point")
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
  @pragma("vm:entry-point")
  static void _scheduleWeeklyAlarm(AlarmItem alarm, tz.TZDateTime now, int weekday) async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfWeekday(now, weekday, alarm.selectedTime);

    await AndroidAlarmManager.periodic(
      const Duration(days: 7), // Weekly repetition
      alarm.id + weekday, // Unique ID for each weekday alarm
      AlarmRing.alarmCallback,
      params: alarm.toJson(),
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
