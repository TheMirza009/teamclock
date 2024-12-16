import 'package:flutter/material.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTimezoneDialogTest extends StatefulWidget {
  final void Function(String timezone, tz.TZDateTime selectedTime) onTimezoneAdded;

  const AddTimezoneDialogTest({required this.onTimezoneAdded, super.key});

  @override
  State<AddTimezoneDialogTest> createState() => _AddTimezoneDialogTestState();
}

class _AddTimezoneDialogTestState extends State<AddTimezoneDialogTest> {
  String selectedTimezone = 'Asia/Karachi';
  tz.TZDateTime? selectedTime;
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final timezones = tz.timeZoneDatabase.locations.keys.toList();
    final now = TimeFunctions.formatTimeOnly(
      show12HourFormat: true,
      context: context, 
      current: tz.TZDateTime.now(tz.getLocation(selectedTimezone)));
    // final timeLeft = alarm.timeLeft(now);

    return AlertDialog(
      title: Text('Add Alarm', style: ThemeConstants.montserratBold(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectedTime != null 
          ? Text("Selected Time: ${selectedTime?.hour ?? "Hour"}:${selectedTime?.minute ?? "Minute"}") 
          : const Text("Please select an alarm time."),
          // Text("$selectedTimezone Time: ${now.hour.toString().padLeft(2, "0") ?? "Hour"}:${now.minute.toString().padLeft(2, "0") ?? "Minute"}"),
          Text("$selectedTimezone Time: $now"),
          OutlinedButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AddTimezoneDialog(
                        onTimezoneAdded: (timezone) {
                          setState(() => selectedTimezone = timezone);
                        },
                      );
                    },
                  ),
              child: Text("Timezone: $selectedTimezone", style: ThemeConstants.notBoldText(context))),
          OutlinedButton(
            child: Text('Pick Alarm Time',
                style: ThemeConstants.notBoldText(context)),
            onPressed: () async {
              final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  );
              if (time != null) {
                final now = tz.TZDateTime.now(tz.getLocation(selectedTimezone));
                setState(() {
                  selectedTime = tz.TZDateTime(
                    tz.getLocation(selectedTimezone),
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            },
          ),
          isEmpty ? const Text("Please select a Timezone and Alarm time to add new Alarm.", style: TextStyle(color: Colors.red))
          : const SizedBox.shrink()
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selectedTime != null) {
              widget.onTimezoneAdded(selectedTimezone, selectedTime!);
              Navigator.pop(context);
            } else {
              isEmpty = true;
              setState(() {
                Future.delayed(Duration(seconds: 2), () => setState(() {
                  isEmpty = false;
                }));
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
