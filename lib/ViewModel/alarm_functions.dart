import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_test_screen.dart';

class AlarmFunctions {
  static final AudioPlayer player = AudioPlayer();

  static void stopAlarm(AlarmItem alarmItem, WidgetRef ref) async {
    await player.stop();
    alarmItem.isRinging = false;
  }

  static Future<void> playAlarmSound() async {
    try {
      await player.setAsset('Assets/sound/alarms/Basic Alarm.mp3');
      player.setLoopMode(LoopMode.one);
      await player.play();
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }
}