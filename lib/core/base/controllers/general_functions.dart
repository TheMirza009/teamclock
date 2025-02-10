import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/viewmodel/task_manager_class.dart';
import 'package:teamclock/core/base/controllers/hive_class.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/timezone_screen.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';

class Functions {

  static void grandReset({
    required BuildContext context,
    required WidgetRef ref,
  }) async {

    // Timezone Screen reset
    final state = timezoneScreenKey.currentState;
    if (state != null) {
      state.clearAllTimezones(); // This will call setState internally
    }

    // Pomodoro States reset
    ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.completedTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.timerNotifierProvider.notifier).reset();
    ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetToDefault(ref);
    TaskManager(ref).clearTasks();

    // Clear HIVE
    HiveFunctions.clearAlldata();

    // re-initializations 
    await TimezoneStates.initializeTimeZone();
    HiveFunctions.loadSettings(ref);
    HiveFunctions.loadAlarms(ref);
    Navigator.of(context).pop(); 
  }
}