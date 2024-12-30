
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/root/Data/models/ringtone_model.dart';
import 'package:time_slider/core/utilities/ringtones_class.dart';
import 'package:time_slider/root/Presentation/Widgets/Alarm%20Components/alarm_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Alarm Item Model
class AlarmItem {
  int id;
  final String title;
  final String timezone;
  final tz.TZDateTime selectedTime;
  final Ringtone ringtone;
  bool isRinging;
  bool deleteAfterRing;
  bool vibrateOnRing;
  bool isActive;

  AlarmItem({
    required this.id,
    required this.title,
    required this.timezone,
    required this.selectedTime,
    this.ringtone = const Ringtone(),
    this.isRinging = false,
    this.deleteAfterRing = false,
    this.vibrateOnRing = false,
    this.isActive = true,
  });

  Duration timeLeft(tz.TZDateTime now) => selectedTime.difference(now);
}
