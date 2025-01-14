import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/viewmodel/task_manager_class.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';

class Functions {
  static void grandReset({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    TimezoneStates.timezoneselections = [];
    TimezoneStates.selectedTimeZone = "UTC";
    ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.completedTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.timerNotifierProvider.notifier).reset();
    ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetToDefault(ref);
    TaskManager(ref).clearTasks();
    HiveFunctions.clearAlldata();
    Navigator.of(context).pop(); 
  }
}