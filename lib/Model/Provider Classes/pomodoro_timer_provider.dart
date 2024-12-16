import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/Model/pomodoro_states.dart';

// TimerNotifier manages the countdown timer
class PomodoroTimerNotifier extends StateNotifier<int> {
  final Ref ref;

  PomodoroTimerNotifier(this.ref) : super(ref.read(PomodoroStates.timerDurationsNotifierProvider)[0]!) {
    // Listen to timerDurations changes
    ref.listen<Map<int, int>>(PomodoroStates.timerDurationsNotifierProvider, (_, next) {
      final currentTabIndex = ref.read(PomodoroStates.segmentedControlValue);
      state = next[currentTabIndex]!; // Update timer based on current tab
    });
  }
  Timer? _timer;

//  void playNotificationSound() async {
//     final player = AudioPlayer();
//     await player.play(AssetSource('Assets/sound/simple-notification.mp3'));
//   }

//   final audioPlayer = AudioPlayer();

// // Play the notification sound
//   void playNotificationSound() async {
//     try {
//       await audioPlayer.play(DeviceFileSource("Assets/sound/notification.mp3"));
//       // await audioPlayer.play(AssetSource("Assets/sound/notification.mp3"));
//       // await audioPlayer.play(UrlSource("https://cdn.pixabay.com/download/audio/2024/10/04/audio_f01ddc3f16.mp3?filename=keyboard-typing-sound-247417.mp3"));
//     } catch (e) {
//       print("Error playing sound: $e");
//     }
//   }

  void playNotificationSoundFromJustSound() async {
    final player = AudioPlayer();
    try {
      await player.setAsset('Assets/sound/notification.mp3'); // Correct path
      await player.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void checkAssetExists() async {
    try {
      await rootBundle.load('Assets/sound/notification.mp3');
      print('Asset found and loaded successfully!');
    } catch (e) {
      print('Error: $e');
    }
  }
  // Play the timer (start counting down)
  void play() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
       timer.cancel(); // Stop timer when it reaches zero
      _resetTimer();  // Automatically reset the timer
      }
      if (state < 1) {
        playNotificationSoundFromJustSound();
        NotificationController.showPomodoroNotificationOnEnd();
      }
      // playNotificationSound();
    });
  }

  // Pause the timer
  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  // Reset the timer to the initial duration
  void reset() {
    pause(); // Stop any active timer
    _resetTimer();
  }

  // Helper to reset the timer state based on the selected segment
  void _resetTimer() {
    // final durations = ref.watch(PomodoroStates.timerDurations);
    final selectedSegment = ref.watch(PomodoroStates.segmentedControlValue);
    final durations = ref.watch(PomodoroStates.timerDurationsNotifierProvider);
    ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
    state = durations[selectedSegment] ?? 0;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up resources
    super.dispose();
  }
}

