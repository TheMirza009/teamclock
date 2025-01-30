import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_timer_provider.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/time_durations_notifier.dart';
import 'package:teamclock/core/theme/theme_constants.dart';

// Define additional state providers
class PomodoroStates {
  
  // Riverpod States
  static final isPlayingProvider = StateProvider<bool>((ref) => false);
  static final segmentedControlValue = StateProvider<int>((ref) => 0);
  static final taskSegmentControlValue = StateProvider<int>((ref) => 0);
  static final timerDurations = StateProvider<Map<int, int>>((ref) => {
    0: 3600, // Focus (25 min)
    1: 300,  // Short Break (5 min)
    2: 900,  // Long Break (15 min)
  });

  // Petty States
  static final resetLock = StateProvider<bool>((ref) => false);
  static final containerHeight = StateProvider<double>((ref) => 0.45);
  static final textStyleDynamic = StateProvider((ref) => GoogleFonts.montserrat(fontSize: ThemeConstants.getDynamicFontSize(104))); 
  static final timerNotifierProvider =
      StateNotifierProvider<PomodoroTimerNotifier, int>(
          (ref) => PomodoroTimerNotifier(ref));

  static final timerDurationsNotifierProvider =
      StateNotifierProvider<TimerDurationsNotifier, Map<int, int>>(
          (ref) => TimerDurationsNotifier());

  // Task States
  static final pendingTasksProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);
  static final completedTasksProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

}
