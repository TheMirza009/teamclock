import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownWidget extends StatefulWidget {
  final bool isPlaying;
  final int timerDuration; // Duration in seconds (e.g., 1500 for 25 minutes)
  const CountdownWidget({
    super.key,
    required this.isPlaying,
    required this.timerDuration,
  });

  @override
  CountdownWidgetState createState() => CountdownWidgetState();
}

class CountdownWidgetState extends State<CountdownWidget> {
  late ValueNotifier<int> countdownNotifier;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    countdownNotifier = ValueNotifier<int>(widget.timerDuration); // Set initial value based on the passed duration
    _handleTimerState();
  }

  @override
  void didUpdateWidget(CountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      _handleTimerState();
    }
    // Update timer duration if changed
    if (widget.timerDuration != oldWidget.timerDuration) {
      countdownNotifier.value = widget.timerDuration;
    }
  }

  void _handleTimerState() {
    if (widget.isPlaying) {
      _startCountdown();
    } else {
      _pauseCountdown();
    }
  }

  void _startCountdown() {
    countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownNotifier.value > 0) {
        countdownNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _pauseCountdown() {
    countdownTimer?.cancel();
    countdownTimer = null;
  }

  void resetTimer() {
    countdownNotifier.value = widget.timerDuration; // Reset to initial duration
    _pauseCountdown(); // Stop the timer if it was running
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    countdownNotifier.dispose();
    super.dispose();
  }

  String formatTimeFromSeconds(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '${NumberFormat("00").format(hours)}:${NumberFormat("00").format(minutes)}:${NumberFormat("00").format(remainingSeconds)}';
  } else {
    return '${NumberFormat("00").format(minutes)}:${NumberFormat("00").format(remainingSeconds)}';
  }
}

   @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: countdownNotifier,
      builder: (context, child) {
        final isHoursDisplayed = (countdownNotifier.value ~/ 3600) > 0;
        
        return Text(
          formatTimeFromSeconds(countdownNotifier.value),
          style: isHoursDisplayed
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.titleLarge,
        );
      },
    );
  }
}
