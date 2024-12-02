import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/View/Drawer/drawer_content.dart';
import 'package:time_slider/View/Utils/Animations/fade_slide_transition.dart';
import 'package:time_slider/View/Utils/Animations/slide_fade_transition.dart';
import 'package:time_slider/View/Utils/drawerIcon.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/Model/Provider%20Classes/stopwatch_provider_class.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';

class StopwatchScreen extends ConsumerWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatchState = ref.watch(stopwatchProvider);
    final stopwatchNotifier = ref.read(stopwatchProvider.notifier);

    // String formatDuration(Duration duration) {
    //   String twoDigits(int n) => n.toString().padLeft(2, "0");
    //   final hours = twoDigits(duration.inHours);
    //   final minutes = twoDigits(duration.inMinutes.remainder(60));
    //   final seconds = twoDigits(duration.inSeconds.remainder(60));
    //   final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, "0");
    //   return hours != "00" ? "$hours:$minutes:$seconds.$milliseconds" : "$minutes:$seconds.$milliseconds";
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: buildDrawerIconButton(context),
        title: ThemeConstants.pageTitle(context, "Stopwatch"),
      ),
      drawer: const DrawerContent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              TimeFunctions.formatDuration(stopwatchState.elapsed),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: stopwatchState.isRunning
                      ? stopwatchNotifier.stopTimer
                      : stopwatchNotifier.startTimer,
                  icon: Icon(
                    stopwatchState.isRunning ? Icons.pause : Icons.play_arrow,
                    size: ThemeConstants.getDynamicFontSize(50),
                  ),
                ),
                stopwatchState.elapsed != Duration.zero
                    ? IconButton(
                        onPressed: stopwatchState.isRunning
                            ? stopwatchNotifier.recordLap
                            : stopwatchNotifier.resetTimer,
                        icon: Icon(
                          stopwatchState.isRunning ? Icons.flag : Icons.stop,
                          size: ThemeConstants.getDynamicFontSize(50),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Expanded(
                child: AnimatedList(
              key: stopwatchNotifier.lapsListKey,
              initialItemCount: stopwatchState.laps.length,
              itemBuilder: (context, index, animation) {
                // Animate individual laps
                return SlideFadeTransition(
                  animation: animation,
                  child: ListTile(
                    title: Text("Lap ${index + 1}"),
                    subtitle: Text(TimeFunctions.formatDuration(
                        stopwatchState.laps[index])),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
