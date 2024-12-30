import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier class to manage the fading animation
class FadingAnimationNotifier extends Notifier<double> {
  late Timer _timer;

  @override
  double build() {
    // Initial opacity
    _startFading();
    return 1.0;
  }

  // Start fading by toggling opacity every 500ms
  void _startFading() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      state = state == 1.0 ? 0.0 : 1.0; // Toggle opacity
    });
  }

  // Reset animation to fully visible
  void resetAnimation() {
    state = 1.0; // Reset opacity to full
  }

  // @override
  // void dispose() {
  //   _timer.cancel(); // Stop timer when the notifier is disposed
  //   super.dispose();
  // }
}

// Riverpod provider for the notifier
final fadingAnimationProvider = NotifierProvider<FadingAnimationNotifier, double>(() {
  return FadingAnimationNotifier();
});
