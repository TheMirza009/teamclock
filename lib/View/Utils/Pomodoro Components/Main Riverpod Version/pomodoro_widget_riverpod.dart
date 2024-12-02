import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_slider/Model/Provider%20Classes/task_manager_class.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Pomodoro%20Dialogues/tuning_dialogue_ios.dart';
import 'package:time_slider/View/Utils/Pomodoro%20Components/Segmented%20Control/pomodoro_segmented_control.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';


class PomodoroMainRiverpod extends ConsumerStatefulWidget {
  const PomodoroMainRiverpod({super.key});

  @override
  ConsumerState<PomodoroMainRiverpod> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends ConsumerState<PomodoroMainRiverpod> {
  final timerNotifierProvider = PomodoroStates.timerNotifierProvider;
  final timerDurationsNotifierProvider = PomodoroStates.timerDurationsNotifierProvider;

  // @override
  // void initState() {
  //   super.initState();

  //   // Listen to timer changes and check for value >= 3600
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.listen<int>(timerNotifierProvider, (previous, current) {
  //       if (current >= 3600) {
  //         debugPrint("Timer value reached or exceeded 3600 seconds!");
  //         // Trigger any state or perform actions here
  //         setState(() {});
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData themeContext = Theme.of(context);
    Size mediaSize = MediaQuery.sizeOf(context);

    final timerValue = ref.watch(timerNotifierProvider);
    final tabIndex = ref.watch(PomodoroStates.segmentedControlValue);
    final isPlaying = ref.watch(PomodoroStates.isPlayingProvider);

    toggleTimer() {
      isPlaying 
      ? ref.read(timerNotifierProvider.notifier).pause() 
      : ref.read(timerNotifierProvider.notifier).play();
      ref.read(PomodoroStates.isPlayingProvider.notifier).state = !isPlaying;
    }

    handleSegmentChange(int value) {
      ref.read(timerNotifierProvider.notifier).pause();
      ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
      ref.read(PomodoroStates.segmentedControlValue.notifier).state = value;
      ref.read(timerDurationsNotifierProvider.notifier).resetAllTimers();
    }

    resetTimerFunction() {
      ref.read(timerNotifierProvider.notifier).pause();
      ref.read(timerDurationsNotifierProvider.notifier).resetAllTimers();
      ref.read(PomodoroStates.isPlayingProvider.notifier).state = false;
    }

    // ref.listen<int>(timerNotifierProvider, (previous, current) {
    //     if (current >= 3600) {
    //       debugPrint("Timer value reached or exceeded 3600 seconds!");
    //       // Trigger any state or perform actions here
    //       // setState(() {});
    //     }
    //   });

    void testReset() {
      ref.read(timerDurationsNotifierProvider.notifier).state =  Map<int, int>.from({0: 3, 1: 3, 2: 3});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        backgroundColor: themeContext.colorScheme.surfaceContainer,
        content: Row(children: [
          Text('Test Reset: ', style: ThemeConstants.montserratBold(context)),
          Text('Timer set to 3 seconds.', style: TextStyle(color: themeContext.colorScheme.primary)),
        ],),
        
        duration: const Duration(seconds: 1),
      ));
    }

    return Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          height: ThemeConstants.screenHeight * 0.33,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [

                // MAIN SEGMENTED CONTROLS : FOCUS | SHORT BREAK | LONG BREAK
                MainSegmentedControls(
                  timerTab: tabIndex,
                  onSegmentChanged: (value) => setState(() {
                    handleSegmentChange(value);
                  }),
                ),

                // MAIN COUNTDOWN TIMER
                GestureDetector(
                  onTap: () => testReset(),
                  child: Text(
                    TimeFunctions.formatTimeFromSeconds(timerValue),
                    style: timerValue >= 3600
                        ? themeContext.textTheme.titleMedium
                        : themeContext.textTheme.titleLarge,
                  ),
                ),

                // CONTROL BUTTONS
                Align(
                  alignment: Alignment.bottomCenter,
                  child: controlButtons(
                    ref: ref,
                    isPlaying: isPlaying,
                    mediaSize: mediaSize,
                    themeContext: themeContext,
                    onPlayPressed: toggleTimer,
                    onResetPressed: resetTimerFunction,
                    onTunePressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const TuningDialogueIOS()
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget controlButtons({
    required WidgetRef ref,
    required bool isPlaying,
    required Size mediaSize,
    required ThemeData themeContext,
    required onPlayPressed,
    required onResetPressed,
    required onTunePressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconButton(
          context: themeContext,
          mediaSize: mediaSize,
          icon: Icons.refresh,
          onPressed: onResetPressed,
        ),
        const SizedBox(width: 16),
        _iconButton(
          iconSize: 0.12,
          context: themeContext,
          mediaSize: mediaSize,
          icon: isPlaying ? Icons.pause : Icons.play_arrow,
          onPressed: onPlayPressed,
        ),
        const SizedBox(width: 16),
        _iconButton(
          isTuneIcon: true,
          context: themeContext,
          mediaSize: mediaSize,
          icon: Icons.tune,
          onPressed: onTunePressed,
        ),
      ],
    );
  }

  Widget _iconButton({
    required ThemeData context,
    required Size mediaSize,
    required IconData icon,
    required VoidCallback onPressed,
    bool isTuneIcon = false,
    double iconSize = 0.07,
  }) {
    final tuneIcon = SvgPicture.asset(
      "Assets/icons/tune1.svg",
      color: context.colorScheme.primary,
      height: ThemeConstants.screenHeight * 0.017, // 2% of screen height
    );
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        iconSize: mediaSize.width * iconSize,
        onPressed: onPressed,
        icon: isTuneIcon 
        ? tuneIcon 
        : Icon( icon, color: context.colorScheme.primary),
      ),
    );
  }
}

// ElevatedButton(
//    onPressed: () {
//      ref.read(timerDurationsNotifierProvider.notifier).updateTimeDuration(
//        index: tabIndex,
//        seconds: 60,
//        ref: ref,
//      );
//    },
//    child: const Text("Add 60 seconds to timer"),
//  ),
//  ElevatedButton(
//    onPressed: () {
//      ref.read(timerDurationsNotifierProvider.notifier).resetToDefault();
//    },
//    child: const Text("Reset Values to default"),
//  ),
