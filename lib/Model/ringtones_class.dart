class Ringtones {
  static const String basicAlarm = 'Assets/sound/alarms/Basic Alarm.mp3';
  static const String fireAlarm = 'Assets/sound/alarms/Fire Alarm.mp3';
  static const String beepAlarm = 'Assets/sound/alarms/Beep Alarm.mp3';
  static const String morningAlarm = 'Assets/sound/alarms/Morning Alarm.mp3';
  static const String electronicAlarm = 'Assets/sound/alarms/Electronic Alarm.mp3';

  // List of all ringtone paths
  static final List<String> allRingtones = [
    basicAlarm,
    fireAlarm,
    beepAlarm,
    morningAlarm,
    electronicAlarm,
  ];

  /// Extracts the title of the .mp3 file from the given path
  static String extractTitle(String path) {
    final fileName = path.split('/').last;
    return fileName.replaceAll('.mp3', '');
  }
}
