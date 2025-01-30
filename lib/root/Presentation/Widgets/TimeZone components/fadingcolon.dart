import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/core/base/animations/fading_animation_notifier.dart';

class FadingWidget extends ConsumerWidget {
  final Widget? child;
  const FadingWidget({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the opacity state from the provider
    final opacity = ref.watch(fadingAnimationProvider);

    return Center(
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 250),
        child: child,
      ),
    );
  }
}
