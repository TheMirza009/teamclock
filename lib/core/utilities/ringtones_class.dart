class Ringtones {
  static const String basicAlarm = 'Assets/sound/alarms/Basic Alarm.mp3';
  static const String fireAlarm = 'Assets/sound/alarms/Fire Alarm.mp3';
  static const String beepAlarm = 'Assets/sound/alarms/Beep Alarm.mp3';
  static const String morningAlarm = 'Assets/sound/alarms/Morning Alarm.mp3';
  static const String electronicAlarm = 'Assets/sound/alarms/Electronic Alarm.mp3';
  static const String sampleRingtone = 'Assets/sound/alarms/Sample ringtone.mp3';
  static const String notification1 = 'Assets/sound/alarms/Notification 1.mp3';

  // List of all ringtone paths
  static final List<String> allRingtones = [
    basicAlarm,
    fireAlarm,
    beepAlarm,
    morningAlarm,
    electronicAlarm,
    sampleRingtone,
    notification1,
  ];

  static const defaultRingtone = basicAlarm;

  /// Extracts the title of the .mp3 file from the given path
  static String extractTitle(String path) {
    final fileName = path.split('/').last;
    return fileName.replaceAll('.mp3', '');
  }
}
