
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Alarm Item Model
class AlarmItem {
  int id;
  final String title;
  final String timezone;
  final tz.TZDateTime selectedTime;
  final String ringtone;
  bool isRinging;
  bool isActive;

  AlarmItem({
    required this.id,
    required this.title,
    required this.timezone,
    required this.selectedTime,
    this.ringtone = 'Assets/sound/alarms/Basic Alarm.mp3',
    this.isRinging = false,
    this.isActive = true,
  });

  Duration timeLeft(tz.TZDateTime now) => selectedTime.difference(now);
}