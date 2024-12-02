import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/pomodoro_states.dart';

class DurationPickerDialog extends ConsumerWidget {
  final int currentDuration;
  final int tabIndex;
  const DurationPickerDialog({
    super.key, 
    required this.currentDuration,
    required this.tabIndex,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController(text: currentDuration.toString());

    void updateValue(int change) {
      final currentValue = int.tryParse(controller.text) ?? 0;
      final newValue = currentValue + change;
      controller.text = newValue.clamp(1, 999).toString(); // Clamp between 1 and 999
    }

    return CupertinoAlertDialog(
      title: const Text("Select Duration"),
      content: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "Use the buttons or click to edit interval:",
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.minus_circle, size: 30),
                onPressed: () => updateValue(-1),
              ),
              const SizedBox(width: 12),
              Transform.translate(
                offset: const Offset(0,5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      child: CupertinoTextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.primary
                        ),
                        decoration: BoxDecoration(
                          // border: Border.all(color: CupertinoColors.systemGrey3),
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Text(
                        "minutes",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.plus_circle, size: 30),
                onPressed: () => updateValue(1),
              ),
            ],
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context); // Close the dialog without any action
          },
        ),
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () {
            final enteredValue = int.tryParse(controller.text) ?? 25; // Default to 25 if invalid
            ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).updateTimeDuration(
              index: tabIndex,
              minutes: enteredValue,
              ref: ref,
            );
            Navigator.pop(context); // Close the dialog
          },
        ),
      ],
    );
  }
}
