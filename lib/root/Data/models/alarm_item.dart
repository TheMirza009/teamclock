import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:teamclock/root/Data/models/ringtone_model.dart';
import 'package:teamclock/core/utilities/ringtones_class.dart';
import 'package:teamclock/root/Data/models/weekdays_model.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Alarm Item Model
class AlarmItem {
  int id;
  final String title;
  final String timezone;
  final tz.TZDateTime selectedTime;
  final Ringtone ringtone;
  Weekday repeat;
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
    this.repeat = const Weekday(),
    this.isRinging = false,
    this.deleteAfterRing = false,
    this.vibrateOnRing = false,
    this.isActive = true,
  });

  Duration timeLeft(tz.TZDateTime now) => selectedTime.difference(now);

  // Empty alarm constructor with default values
  factory AlarmItem.emptyAlarm() {
    final currentTime = tz.TZDateTime.now(tz.getLocation(TimezoneStates.localTimezoneGlobal));

    return AlarmItem(
      id: 000,  // Default ID
      title: "Default Alarm",
      timezone: TimezoneStates.localTimezoneGlobal,  // Use the global timezone
      selectedTime: currentTime,  // Use the current time in selectedTime
      ringtone: const Ringtone( loop: LoopMode.one,  path: Ringtones.defaultRingtone ),
      vibrateOnRing: false,
      isRinging: false,
      isActive: false,
    );
  }

  // fromJson method to map the JSON data to AlarmItem object
  factory AlarmItem.fromJson(Map<String, dynamic> json) {
    // Parsing selectedTime into TZDateTime
    final selectedTime = tz.TZDateTime.parse(tz.getLocation(json['timezone']), json['selectedTime']);
    final ringtone = Ringtone.fromJson(json['ringtone']);  // Assuming Ringtone has a fromJson method
    final Weekday weekdays = Weekday.fromJson(json['repeat']);

    return AlarmItem(
      id: json['id'],
      title: json['title'],
      timezone: json['timezone'],
      selectedTime: selectedTime,
      ringtone: ringtone,
      repeat: weekdays,
      isActive: json['isActive'],
      vibrateOnRing: json['vibrateOnRing'],
      isRinging: json['isRinging'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timezone': timezone,
      'selectedTime': selectedTime.toIso8601String(),  // Convert TZDateTime to ISO string
      'ringtone': ringtone.toJson(),  // Ringtone toJson method
      'repeat': repeat.toJson(),
      'isActive': isActive,
      'vibrateOnRing': vibrateOnRing,
      'isRinging': isRinging,
    };
  }
}
