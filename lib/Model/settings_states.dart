import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsStates {
  static final showSeconds = StateProvider<bool>((ref) => false);
  static final show12HourFormat = StateProvider<bool>((ref) => true);
  static const originalDurations = {
    0: 1500, // Focus (25 min)
    1: 300, // Short Break (5 min)
    2: 900, // Long Break (15 min)
  };
  static Map<int,int> initialDurations = {
    0: 8, // Focus (25 min)
    1: 300, // Short Break (5 min)
    2: 900, // Long Break (15 min)
  };
}