// FadeSlideTransition for resetting all laps
import 'package:flutter/material.dart';

class FadeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const FadeSlideTransition({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    // Fade and slide the item
    final fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOut),
    );

    final slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.5, 0)).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}