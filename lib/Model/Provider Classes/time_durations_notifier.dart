import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/Model/settings_states.dart';

class TimerDurationsNotifier extends StateNotifier<Map<int, int>> {
  late Map<int, int> currentState; // Store the current default state

  TimerDurationsNotifier()
      // : super({
      //     0: 5, // Focus (25 min)
      //     1: 300,  // Short Break (5 min)
      //     2: 900,  // Long Break (15 min)
      //   })
      : super(Map<int, int>.from(SettingsStates.initialDurations)) 
  {
    currentState = Map<int, int>.from(state); // DefaultState is now initialized with super state values
  }

  // Update focusDuration to use the current state directly
  int getDuration(int index) {
    final durationInSeconds = state[index] ?? 0;
    return durationInSeconds ~/ 60; // Return the value in minutes
  }

  // Update Durations from MAP
  void updateAllDurations(Map<int, int> newDurations) {
    state = Map<int, int>.from(newDurations);
    currentState = Map<int, int>.from(newDurations);
  }


  /// Updates the timer duration for the given index
  void updateTimeDuration({
    required int index,
    required int minutes,
    required WidgetRef ref,
  }) {
    final updatedMap = Map<int, int>.from(state); // Clone the map
    // updatedMap[index] = (updatedMap[index] ?? 0) + seconds; // Add seconds
    updatedMap[index] = minutes * 60; // Add seconds
    currentState = Map<int, int>.from(updatedMap); // Update the default state to reflect the latest state

    // Reset the timer and stop playing
    ref.read(PomodoroStates.timerNotifierProvider.notifier).reset();
    ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
    print("Updated Duration: ${updatedMap[index]}");
    state = updatedMap; // Trigger state update
    HiveFunctions.saveSettings(ref);
  }

  /// Resets the duration for all timers to the latest updated default values
  void resetAllTimers() {
    state = Map<int, int>.from(currentState); // Use the latest default state
    print("Timers reset to: $currentState");
  }

  void resetToDefault(WidgetRef ref) {
    state = Map<int, int>.from(SettingsStates.originalDurations); // Use the latest default state
    currentState = Map<int, int>.from(SettingsStates.originalDurations); // Use the latest default state
    HiveFunctions.saveSettings(ref);
    print("Timers reset to: ${SettingsStates.originalDurations}");
  }
}
