import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';

class AlarmStates {
  static final alarmSwitchProvider = StateProvider.family<bool, int>((ref, index) => true);
  static final alarmsProvider = StateProvider<List<AlarmItem>>((ref) => []);
}