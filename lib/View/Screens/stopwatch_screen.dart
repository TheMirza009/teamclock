import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/View/Drawer/drawer_content.dart';
import 'package:time_slider/View/Utils/Animations/slide_fade_transition.dart';
import 'package:time_slider/View/Utils/drawerIcon.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/Model/Provider%20Classes/stopwatch_provider_class.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppBar _appbar = AppBar(
      backgroundColor: Colors.transparent,
      leading: buildDrawerIconButton(context),
      title: ThemeConstants.pageTitle(context, "Stopwatch"),
    );

    return Scaffold(
      appBar: _appbar,
      drawer: const DrawerContent(),
      body: Stack(
        children: [

          // TIMER
          Consumer(
            builder: (context, ref, child) {
              final stopwatchState = ref.watch(stopwatchProvider);
              return AnimatedAlign(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
                alignment: stopwatchState.elapsed == Duration.zero
                 ? Alignment.center
                 : Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    TimeFunctions.formatDuration(stopwatchState.elapsed),
                    style: ThemeConstants.robotoMono,
                  ),
                ),
              );
            },
          ),

          // LAP LIST
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final stopwatchState = ref.watch(stopwatchProvider);
                      final stopwatchNotifier = ref.read(stopwatchProvider.notifier);

                      return AnimatedList(
                        key: ref.watch(lapsListKeyProvider),
                        initialItemCount: stopwatchState.laps.length,
                        itemBuilder: (context, index, animation) {
                          return SlideFadeTransition(
                            animation: animation,
                            child: ListTile(
                              title: Text("Lap ${index + 1}"),
                              subtitle: Text(TimeFunctions.formatDuration(stopwatchState.laps[index])),
                              trailing: Text(TimeFunctions.formatTimeFromDateTime(DateTime.now()),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ICON BUTTONS
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Consumer(
              builder: (context, ref, child) {
                final stopwatchState = ref.watch(stopwatchProvider);
                final stopwatchNotifier = ref.read(stopwatchProvider.notifier);

                return Row(
                  mainAxisAlignment: stopwatchState.elapsed != Duration.zero
                   ? MainAxisAlignment.spaceEvenly
                   : MainAxisAlignment.center,
                  children: [

                    // PLAY / PAUSE - BUTTON
                    IconButton(
                      onPressed: stopwatchState.isRunning
                       ? stopwatchNotifier.stopTimer
                       : stopwatchNotifier.startTimer,
                      icon: Icon(
                        stopwatchState.isRunning
                         ? CupertinoIcons.pause
                         : CupertinoIcons.play_arrow,
                        size: ThemeConstants.getDynamicFontSize(50),
                        color: ThemeConstants.neutralblue,
                      ),
                    ),

                    // FLAG / STOP - BUTTON
                    if (stopwatchState.elapsed != Duration.zero)
                      IconButton(
                        onPressed: () => stopwatchState.isRunning
                            ? stopwatchNotifier.recordLap(ref)
                            : stopwatchNotifier.resetTimer(ref),
                        icon: Icon(
                          stopwatchState.isRunning
                           ? CupertinoIcons.flag
                           : CupertinoIcons.stop,
                          size: ThemeConstants.getDynamicFontSize(40),
                          color: ThemeConstants.neutralblue
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
