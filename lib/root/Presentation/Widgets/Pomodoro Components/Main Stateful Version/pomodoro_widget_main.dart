import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/root/Presentation/Widgets/Pomodoro%20Components/Main%20Stateful%20Version/pomodoro_countdown_widget.dart';
import 'package:teamclock/root/Presentation/Widgets/Pomodoro%20Components/Segmented%20Control/pomodoro_segmented_control.dart';
import 'package:teamclock/root/Presentation/Widgets/Pomodoro%20Components/Main%20Stateful%20Version/pomodoro_button_row.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';  // Import your provider file

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  bool isPlaying = false;

  // Define a GlobalKey for accessing CountdownWidget's state
  final GlobalKey<CountdownWidgetState> countdownKey = GlobalKey<CountdownWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer, // Your custom background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer(
          builder: (context, ref, _) {
            // Watch the timerDurations and segmentedControlValue from your provider
            final timerDurations = ref.watch(PomodoroStates.timerDurations);
            final tabIndex = ref.watch(PomodoroStates.segmentedControlValue);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Segmented Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MainSegmentedControls(
                    timerTab: tabIndex,
                    onSegmentChanged: (int value) {
                      setState(() {
                        ref.read(PomodoroStates
                        .segmentedControlValue
                        .notifier).state = value; // Update the provider
                        isPlaying = false;
                      });
                    },
                  ),
                ),

                // Countdown Timer
                InkWell(
                  onTap: () {
                    // Handle any reset logic or tap actions here
                    print(TimezoneFunctions.formatTimeFromSeconds(
                        countdownKey.currentState!.countdownNotifier.value));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CountdownWidget(
                      key: countdownKey,
                      isPlaying: isPlaying,
                      timerDuration: timerDurations[tabIndex]!, // Access the duration from the map
                    ),
                  ),
                ),

                // Time Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).primaryColor,
                    ),
                    height: 4,
                    width: double.infinity,
                  ),
                ),

                // Button Row
                buttonRow(
                  context: context,
                  isPlaying: isPlaying,
                  isEnabled: countdownKey.currentState?.countdownNotifier.value ==
                      timerDurations[tabIndex]!,
                  onResetPressed: () => setState(() {
                    countdownKey.currentState?.resetTimer();
                    isPlaying = false;
                  }),
                  onPlayPressed: () => setState(() {
                    isPlaying = !isPlaying; // Toggle the play/pause button
                  }),
                  onTuningPressed: () => setState(() {}),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
