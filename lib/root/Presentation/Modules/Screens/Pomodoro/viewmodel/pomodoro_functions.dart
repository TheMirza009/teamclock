// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/core/base/dependency_classes/app_lifecycle_provider.dart';
import 'package:teamclock/core/base/controllers/notification_controller.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/viewmodel/task_manager_class.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:teamclock/core/theme/theme_constants.dart';

class PomodoroFunctions {
  static void tabShift({
    required bool value,
    required int index,
    required int currentTab,
    required WidgetRef ref,
  }) async {

    // Task Watch
    final pendingTasksNotifier = ref.read(PomodoroStates.pendingTasksProvider.notifier);
    final completedTasksNotifier = ref.read(PomodoroStates.completedTasksProvider.notifier);

    // Take the item from PendingTasks and add it to
    if (currentTab == 0 && value == true) {
      final task = ref.watch(PomodoroStates.pendingTasksProvider)[index];
      task['value'] = true;

      completedTasksNotifier.state = [
        ...completedTasksNotifier.state, task, // Add to completed
      ];

      Future.delayed(const Duration(milliseconds: 350), () {
      pendingTasksNotifier.state = pendingTasksNotifier.state
          .where((t) => t != task) // Remove from pending tasks
          .toList();
      });

      // completedTasksNotifier.state.add(task);
      // pendingTasksNotifier.state.remove(task);
      await TaskManager(ref).saveTasks();
    } else if (currentTab == 1 && value == false) {
      final task = ref.watch(PomodoroStates.completedTasksProvider)[index];
      task['value'] = false;

      pendingTasksNotifier.state = [
        ...pendingTasksNotifier.state, task, // Add to completed
      ];

      Future.delayed(const Duration(milliseconds: 300), () {
        completedTasksNotifier.state = completedTasksNotifier.state
            .where((t) => t != task) // Remove from pending tasks
            .toList();
      });


      // pendingTasksNotifier.state.add(task);
      // completedTasksNotifier.state.remove(task);
      await TaskManager(ref).saveTasks();
    }
  }

  static void addTask({
    required String taskText,
    required WidgetRef ref,
  }) async {
    // Create a new task
    final newTask = {
      "text": taskText,
      "value": false, // Set it as a pending task by default
      "time": DateTime.now(),
    };

    // Update the state with a new list
    ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [
      ...ref.read(PomodoroStates.pendingTasksProvider),
      newTask
    ];

    await TaskManager(ref).saveTasks();
  }

  // Function to delete a task
  static void deleteTask({
    required int index,
    required int currentTab,
    required WidgetRef ref,
  }) async {
    final pendingTasksNotifier =  ref.read(PomodoroStates.pendingTasksProvider.notifier); // Access pendingTasksProvider
    final completedTasksNotifier = ref.read(PomodoroStates.completedTasksProvider.notifier); // Access completedTasksProvider

    if (currentTab == 0) {
      // Remove the task from the pending tasks and update state
      pendingTasksNotifier.state = [
        ...pendingTasksNotifier.state..removeAt(index),
      ];
    } else if (currentTab == 1) {
      // Remove the task from the completed tasks and update state
      completedTasksNotifier.state = [
        ...completedTasksNotifier.state..removeAt(index),
      ];
    }

    await TaskManager(ref).saveTasks();
  }

  static String formatDuration(int durationInMinutes) {
    // Convert minutes to seconds
    int durationInSeconds = durationInMinutes * 60;

    // Convert seconds to hours, minutes, and seconds
    int hours = durationInSeconds ~/ 3600;
    int remainingMinutes = (durationInSeconds % 3600) ~/ 60;
    int remainingSeconds = durationInSeconds % 60;

    // Format the output depending on hours, minutes, and seconds
    if (hours > 0) {
      return "$hours hours ${remainingMinutes == 0 ? "" : "${remainingMinutes}m"}";
    } else if (remainingMinutes > 0) {
      return "$remainingMinutes minutes";
    } else {
      return "$remainingSeconds seconds";
    }
  }

  //? POMODORO MAIN FUNCTIONS

  static void toggleTimer(WidgetRef ref, bool isPlaying) {
    final timerNotifier = ref.read(PomodoroStates.timerNotifierProvider.notifier);
    final isPlayingNotifier = ref.read(PomodoroStates.isPlayingProvider.notifier);
    
    isPlaying 
    ? timerNotifier.pause() 
    : timerNotifier.play();
    isPlayingNotifier.state = !isPlaying;

    // NotificationController.showPomodoroNotificationOnStart(ref);
  }

  static void handleSegmentChange(WidgetRef ref, int value) {
    ref.read(PomodoroStates.timerNotifierProvider.notifier).pause();
    ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
    ref.read(PomodoroStates.segmentedControlValue.notifier).state = value;
    ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetAllTimers();
  }

  static void resetTimer(WidgetRef ref, BuildContext context) {
    final themeContext = Theme.of(context);
    final timerNotifier = ref.read(PomodoroStates.timerNotifierProvider.notifier);
    final durationNotifier = ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier);
    final isPlayingNotifier = ref.read(PomodoroStates.isPlayingProvider.notifier);
    final appLifecycleState = ref.watch(appLifecycleProvider);

    timerNotifier.pause();
    durationNotifier.resetAllTimers();
    isPlayingNotifier.state = false;
    NotificationController.showPomodoroNotificationOnEnd();

    if (appLifecycleState == AppLifecycleState.paused ||
        appLifecycleState == AppLifecycleState.inactive) {
      NotificationController.showPomodoroNotificationOnEnd();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeContext.colorScheme.surfaceContainer,
        content: Text(
          "Timer reset.",
          style: themeContext.textTheme.bodyMedium,
        ),
      ),
    );
  }

  static void testReset(WidgetRef ref, BuildContext context) {
    final themeContext = Theme.of(context);
    ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).state = Map<int, int>.from({0: 3, 1: 3, 2: 3});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeContext.colorScheme.surfaceContainer,
        content: Row(
          children: [
            Text('Test Reset: ',  style: ThemeConstants.montserratBold(context)),
            Text('Timer set to 3 seconds.', style: TextStyle(color: themeContext.colorScheme.primary)),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
