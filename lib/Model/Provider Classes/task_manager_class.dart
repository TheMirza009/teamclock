import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:time_slider/Model/pomodoro_states.dart';

class TaskManager {
  final WidgetRef ref;

  // Constructor takes in a WidgetRef to interact with Riverpod state
  TaskManager(this.ref);

  // Box name for Hive storage
  static const String _boxName = 'timezones';
  static const int _key = 4;

  /// Saves current tasks to Hive
  Future<void> saveTasks() async {
    final box = await Hive.openBox(_boxName);
    final tasks = [
      ref.watch(PomodoroStates.pendingTasksProvider),
      ref.watch(PomodoroStates.completedTasksProvider),
    ];
    await box.put(_key, tasks);
  }

  /// Loads tasks from Hive and updates Riverpod providers
  Future<void> loadTasks() async {
  final box = await Hive.openBox(_boxName);
  if (box.containsKey(_key)) {
    final loadedTasks = box.get(_key) as List<dynamic>;
    if (loadedTasks.length == 2) {
      // Safely check if the elements are maps and cast them to the proper type
      ref.read(PomodoroStates.pendingTasksProvider.notifier).state = List<Map<String, dynamic>>.from(
        loadedTasks[0]?.map((task) => Map<String, dynamic>.from(task)) ?? [],
      );
      ref.read(PomodoroStates.completedTasksProvider.notifier).state = List<Map<String, dynamic>>.from(
        loadedTasks[1]?.map((task) => Map<String, dynamic>.from(task)) ?? [],
      );
    } else {
      ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [];
      ref.read(PomodoroStates.completedTasksProvider.notifier).state = [];
    }
  } else {
    ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.completedTasksProvider.notifier).state = [];
  }
}

  /// Clears tasks from Hive and Riverpod providers
  Future<void> clearTasks() async {
    final box = await Hive.openBox(_boxName);
    if (box.containsKey(_key)) {
      await box.delete(_key);
    }
    ref.read(PomodoroStates.pendingTasksProvider.notifier).state = [];
    ref.read(PomodoroStates.completedTasksProvider.notifier).state = [];
  }
}
