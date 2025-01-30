import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/root/Data/models/alarm_item.dart';

class AlarmStates {
  static final alarmSwitchProvider = StateProvider.family<bool, int>((ref, index) => true);
  static final alarmsProvider = StateProvider<List<AlarmItem>>((ref) => []);
  static List<AlarmItem> alarmList = [];
}