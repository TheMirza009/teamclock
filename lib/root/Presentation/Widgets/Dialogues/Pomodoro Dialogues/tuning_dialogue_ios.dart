import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/Pomodoro%20Dialogues/duration_picker_dialog.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/viewmodel/pomodoro_functions.dart';

class TuningDialogueIOS extends ConsumerWidget {
  const TuningDialogueIOS({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // int focusDuration = ref.watch(PomodoroStates.timerDurationsNotifierProvider.notifier).getDuration(0);
    // int shortbreakduration = ref.watch(PomodoroStates.timerDurationsNotifierProvider.notifier).getDuration(1);
    // int longbreakduration = ref.watch(PomodoroStates.timerDurationsNotifierProvider.notifier).getDuration(2);
    final durations = ref.watch(PomodoroStates.timerDurationsNotifierProvider);

    int focusDuration = (durations[0] ?? 0) ~/ 60; // Convert seconds to minutes
    int shortbreakduration = (durations[1] ?? 0) ~/ 60;
    int longbreakduration = (durations[2] ?? 0) ~/ 60;

    Widget durationOption({
      required WidgetRef ref, // Riverpod ref if necessary
      required BuildContext context,
      required int tabIndex,
      required int duration, // Duration in seconds
      required String title, // Title for the duration option
    }) {

      return CupertinoActionSheetAction(
        onPressed: () {
          // Show the modal with the DurationPickerDialog
          showCupertinoModalPopup(
            context: context,
            builder: (context) => DurationPickerDialog(
              tabIndex: tabIndex,
              currentDuration: duration,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: ThemeConstants.getDynamicFontSize(16),
                ),
              ),
              Text(
                PomodoroFunctions.formatDuration(duration),
                style: GoogleFonts.montserrat(),
              ),
            ],
          ),
        ),
      );
    }



    return CupertinoActionSheet(
      title: Text( 'Duration tuning', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
      message: Text("Select an appropriate duration for the intervals.",
        style: GoogleFonts.montserrat(fontSize: ThemeConstants.getDynamicFontSize(11))
      ),
      actions: <Widget>[
        durationOption(
          ref: ref, 
          context: context, 
          tabIndex: 0, 
          title: "Focus duration",
          duration: focusDuration, 
          ),
        durationOption(
          ref: ref, 
          context: context, 
          tabIndex: 1, 
          title: "Short break duration",
          duration: shortbreakduration, 
          ),
        durationOption(
          ref: ref, 
          context: context, 
          tabIndex: 2, 
          title: "Long break duration",
          duration: longbreakduration, 
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              ref.watch(PomodoroStates.timerDurationsNotifierProvider.notifier).resetToDefault(ref);
            }, child: const Text("Reset interval durations", style: TextStyle(color: CupertinoColors.activeBlue),))
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context); // Close the action sheet
        },
        child: const Text(
          'Confirm',
          style: TextStyle(color: CupertinoColors.destructiveRed),
        ),
      ),
    );
  }
}
