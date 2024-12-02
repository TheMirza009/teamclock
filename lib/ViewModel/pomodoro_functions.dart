// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Provider%20Classes/task_manager_class.dart';
import 'package:time_slider/Model/pomodoro_states.dart';

class PomodoroFunctions {
  static void tabShift({
    required bool value,
    required int index,
    required int currentTab,
    required WidgetRef ref,
  }) async {
    final pendingTasksNotifier =
        ref.read(PomodoroStates.pendingTasksProvider.notifier); // Access pendingTasksProvider
    final completedTasksNotifier = ref
        .read(PomodoroStates.completedTasksProvider.notifier); // Access completedTasksProvider

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

  static toggleTimer({required WidgetRef ref, required bool isPlaying}) {
    isPlaying
        ? ref.read(PomodoroStates.timerNotifierProvider.notifier).pause()
        : ref.read(PomodoroStates.timerNotifierProvider.notifier).play();
    ref.read(PomodoroStates.isPlayingProvider.notifier).state =
        !isPlaying; // Toggle state
  }

  static handleSegmentChange({required WidgetRef ref, required int value}) {
    ref.read(PomodoroStates.isPlayingProvider.notifier).state = false; // Toggle state
    ref.read(PomodoroStates.segmentedControlValue.notifier).state = value;
    ref.read(PomodoroStates.timerNotifierProvider.notifier).reset();
  }
}
