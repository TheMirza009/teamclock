import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/View/Utils/Animations/slide_fade_transition.dart';
import 'package:time_slider/ViewModel/timezone_functions.dart';

class StopwatchState {
  final Duration elapsed;
  final bool isRunning;
  final List<Duration> laps; // Add the laps field

  StopwatchState({
    required this.elapsed,
    required this.isRunning,
    this.laps = const [], // Default to an empty list
  });

  StopwatchState copyWith({
    Duration? elapsed,
    bool? isRunning,
    List<Duration>? laps, // Add laps to copyWith
  }) {
    return StopwatchState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
      laps: laps ?? this.laps, // Copy laps if provided
    );
  }
}

// Stopwatch state provider
final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier();
});

  final lapsListKeyProvider = Provider((ref) => GlobalKey<AnimatedListState>());
class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier() : super(StopwatchState(elapsed: Duration.zero, isRunning: false));

  Stopwatch? _stopwatch;
  Ticker? _ticker;
  // final lapsListKey = GlobalKey<AnimatedListState>();

  void startTimer() {
    if (!state.isRunning) {
      _stopwatch ??= Stopwatch(); // Initialize the stopwatch only once
      _stopwatch?.start();
      state = state.copyWith(isRunning: true);

      _ticker ??= Ticker((_) {
        if (_stopwatch != null && state.isRunning) {
          state = state.copyWith(elapsed: _stopwatch!.elapsed);
        }
      });

      _ticker?.start();
    }
  }

  void pauseTimer() {
    if (state.isRunning) {
      _stopwatch?.stop(); // Freeze the stopwatch
      state = state.copyWith(isRunning: false); // Update the state to reflect pause
    }
  }

  void stopTimer() {
    if (state.isRunning) {
      _stopwatch?.stop();
      _ticker?.stop();
      state = state.copyWith(isRunning: false);
    }
  }

  void resetTimer(WidgetRef ref) {
      final lapsListKey = ref.watch(lapsListKeyProvider);
    // Animate laps removal
    for (int i = state.laps.length - 1; i >= 0; i--) {
      lapsListKey.currentState?.removeItem(
        i,
        (context, animation) => SlideFadeTransition(
          animation: animation,
          child: ListTile(
            title: Text("Lap ${i + 1}"),
            subtitle: Text(TimezoneFunctions.formatDuration(state.laps[i])),
            trailing: Text(
              TimezoneFunctions.formatTimeFromDateTime(DateTime.now()),
              style: TextStyle(color: Colors.red[900]),
            ),
          ),
        ),
      );
    }

    // Stop and reset the stopwatch
    _stopwatch?.stop();
    _stopwatch?.reset();

    // After the animation, reset the state and laps list
    Future.delayed(const Duration(milliseconds: 300), () {
      state = StopwatchState(elapsed: Duration.zero, isRunning: false, laps: []);
      _ticker?.dispose();
      _ticker = null;
      _stopwatch = null; // Reset the stopwatch instance
    });
  }

  void recordLap(WidgetRef ref) {
    final lapsListKey = ref.watch(lapsListKeyProvider);
    final newLaps = [...state.laps, state.elapsed];
    state = state.copyWith(laps: newLaps);

    // Trigger animation for the new lap
    lapsListKey.currentState?.insertItem(newLaps.length - 1);
  }
}
