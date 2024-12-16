
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Alarm Item Model
class AlarmItem {
  final String timezone;
  final tz.TZDateTime selectedTime;
  bool isRinging;

  AlarmItem({
    required this.timezone,
    required this.selectedTime,
    this.isRinging = false,
  });

  Duration timeLeft(tz.TZDateTime now) => selectedTime.difference(now);
}