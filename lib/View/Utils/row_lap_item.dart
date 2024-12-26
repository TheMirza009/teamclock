import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Provider%20Classes/stopwatch_provider_class.dart';
import 'package:time_slider/View/Utils/Animations/slide_fade_transition.dart';
import 'package:time_slider/ViewModel/timezone_functions.dart';

class RowLap extends ConsumerWidget {
  const RowLap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatchState = ref.watch(stopwatchProvider);
    final stopwatchNotifier = ref.read(stopwatchProvider.notifier);
    return Expanded(
      child: AnimatedList(
        key: ref.watch(lapsListKeyProvider),
        initialItemCount: stopwatchState.laps.length,
        itemBuilder: (context, index, animation) {
          return SlideFadeTransition(
            animation: animation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: index == stopwatchState.laps.length - 1
                ? Theme.of(context).primaryColor.withOpacity(0.1) // Highlight the most recent lap
                : Colors.transparent, // Default background for older laps
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // LAP NUMBER : LEADING
                  Text("Lap ${index + 1}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // ACTUAL LAP TIME : CENTER
                  Text(TimezoneFunctions.formatDuration(stopwatchState.laps[index]),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // CURRENT TIME : TRAILING
                  Text(
                    TimezoneFunctions.formatTimeFromDateTime(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
