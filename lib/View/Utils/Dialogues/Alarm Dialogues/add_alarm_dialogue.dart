import 'package:flutter/material.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
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
      current: tz.TZDateTime.now(tz.getLocation(selectedTimezone)),
    );

    return AlertDialog(
      title: Text('Add Alarm', style: ThemeConstants.montserratBold(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timezone and Alarm Time Information
          Text(
            selectedTime != null
                ? "Selected Time: ${selectedTime?.hour ?? "Hour"}:${selectedTime?.minute ?? "Minute"}"
                : "Please select an alarm time.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text("$selectedTimezone Time: $now", style: TextStyle(fontSize: 16)),
          
          // Timezone and Alarm Time Selection
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
            child: Text("Timezone: $selectedTimezone", style: ThemeConstants.notBoldText(context)),
          ),
          OutlinedButton(
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
            child: Text('Pick Alarm Time', style: ThemeConstants.notBoldText(context)),
          ),
          SizedBox(height: 20),
          
          // Error Message if fields are empty
          isEmpty
              ? const Text(
                  "Please select a Timezone and Alarm time to add new Alarm.",
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox.shrink(),
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
              setState(() {
                isEmpty = true;
              });
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  isEmpty = false;
                });
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
