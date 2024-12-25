import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/Model/Models/ringtone_model.dart';
import 'package:time_slider/Model/ringtones_class.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/View/Utils/Dialogues/ringtone_selection_dialog.dart';
import 'package:time_slider/View/Utils/custom_list_tile.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
import 'package:timezone/timezone.dart' as tz;

class AddAlarmScreen extends StatefulWidget {
  final void Function(AlarmItem alarm) onTimezoneAdded;
  const AddAlarmScreen({required this.onTimezoneAdded, super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  int selectedAmPmIndex = 0; // 0 for AM, 1 for PM
  int selectedHourIndex = 0; // Index for hours (0 corresponds to 1)
  int selectedMinuteIndex = 0; // Index for minutes (0 corresponds to 00)
  bool vibrateOnRing = false;
  bool deleteAfterRing = false;
  String selectedTimezone = 'Asia/Karachi';
  bool isEmpty = false;
  bool noTitle = false;

  tz.TZDateTime? _getSelectedTime() {
    // Get the current time zone
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print("LOCAL LOCATION: ${tz.local}");

    // Calculate the selected time based on the pickers
    int selectedHour = selectedHourIndex + 1; // Adding 1 as index starts from 0
    if (selectedAmPmIndex == 1) { // PM
      selectedHour += 12; // Convert PM hours to 24-hour format
    }

    // Set the selected time using the chosen hour and minute
    return tz.TZDateTime(tz.local, now.year, now.month, now.day, selectedHour, selectedMinuteIndex);
  }

  String remainingTimeText = "Alarm sets off in 0 hours, 0 minutes"; // Default text if no time is selected
  String ringtonePath = Ringtones.defaultRingtone;
  LoopMode ringtoneLoopMode = LoopMode.one;
  String alarmTitle = "";


  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    final displayMedium = GoogleFonts.robotoMono(fontWeight: FontWeight.w300, fontSize: 22);

    // if (selectedTime != null) {
    //   final duration = selectedTime!.difference(tz.TZDateTime.now(tz.local));
    //   int hours = duration.inHours;
    //   int minutes = duration.inMinutes % 60;

    //   remainingTimeText = "Alarm sets off in $hours hours, $minutes minutes";
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TOP SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(
                  children: [
                    const Text(
                      "Add Alarm",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      AlarmFunctions.calculateTimeDifference(selectedTimezone, _getSelectedTime()!) ?? remainingTimeText, // Dynamically updated text
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    tz.TZDateTime? selectedTime = _getSelectedTime();
                    final ringtone = Ringtone(path: ringtonePath, loop: ringtoneLoopMode );

                    print("New Alarm set with the following parametres. \nTitle: $alarmTitle\nSelected Timezone: $selectedTimezone\nSelected Time: ${selectedTime?.hour} : ${selectedTime?.minute}");

                    if (selectedTime != null && alarmTitle != "") {
                      AlarmItem newAlarm = AlarmItem(
                        id: DateTime.now().microsecondsSinceEpoch,
                        title: alarmTitle,
                        timezone: selectedTimezone,
                        selectedTime: selectedTime,
                        ringtone: ringtone,
                        deleteAfterRing: deleteAfterRing,
                        vibrateOnRing: vibrateOnRing,
                      );
                      widget.onTimezoneAdded(newAlarm);
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isEmpty = true;
                        noTitle = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          isEmpty = false;
                        });
                      });
                    }
                  },
                  icon: const Icon(Icons.check, size: 30),
                ),
              ],
            ),

            // Cupertino picker
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 30, right: 15),
              child: SizedBox(
                height: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Hours Picker
                    Expanded(
                      child: CupertinoPicker(
                        looping: true,
                        itemExtent: 60,
                        scrollController: FixedExtentScrollController(
                          // initialItem: tz.TZDateTime.now(tz.getLocation(selectedTimezone)).hour, // Convert 24-hour to 12-hour format
                          // initialItem: (DateTime.now().hour % 12), // Convert 24-hour to 12-hour format
                          // initialItem: tz.TZDateTime.now(tz.getLocation(selectedTimezone)).hour, // Convert 24-hour to 12-hour format
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHourIndex = index;
                          });
                        },
                        children: List.generate(
                          12,
                          (index) => Center(
                            child: Text(
                              (index + 1).toString().padLeft(2, '0'),
                              style: displayMedium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Minutes Picker
                    Expanded(
                      child: CupertinoPicker(
                        looping: true,
                        itemExtent: 60,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinuteIndex = index;
                          });
                        },
                        children: List.generate(
                          60,
                          (index) => Center(
                              child: Text(index.toString().padLeft(2, '0'), style: displayMedium)),
                        ),
                      ),
                    ),

                    // AM/PM Picker
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 60,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedAmPmIndex = index;
                          });
                        },
                        children: [
                          Center(child: Text("AM", style: displayMedium)),
                          Center(child: Text("PM", style: displayMedium)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // OPTIONS COLUMN
            Column(
              children: [
                CustomListTile(
                  title: "Title",
                  subtitle: noTitle ? "The title cannot be empty."  : alarmTitle,
                  noTitle: noTitle,
                  onTap: () => _editTitle(context),
                ),
                CustomListTile(
                  title: "Timezone",
                  subtitle: TimeFunctions.getCityAndCountryFromTimezone(selectedTimezone),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AddTimezoneDialog(
                        onTimezoneAdded: (timezone) {
                          setState(() => selectedTimezone = timezone);
                        },
                      );
                    },
                  ),
                ),
                CustomListTile(
                  title: "Ringtone",
                  subtitle:  Ringtones.extractTitle(ringtonePath),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return RingtoneSelectionDialog(
                        onRingtoneSelected: (selectedRingtone) {
                          setState(() {
                            ringtonePath = selectedRingtone;
                          });
                          print("Selected Ringtone: $selectedRingtone");
                        },
                      );
                    },
                  ),
                ),
                CustomListTile(
                  title: "Repeat",
                  subtitle: ringtoneLoopMode == LoopMode.off ? "Once" : "Loop",
                  onTapDown: (details) => showLoopModeMenu(details),
                ),
                CustomListTile(
                  title: "Vibrate on ring",
                  subtitle: "",
                  showChevron: false,
                  trailingWidget: Switch(
                    value: vibrateOnRing,
                    onChanged: (value) {
                      setState(() {
                        vibrateOnRing = value;
                      });
                    }),
                ),
                CustomListTile(
                  title: "Delete after ring",
                  subtitle: "",
                  showDivider: false,
                  showChevron: false,
                  trailingWidget: Switch(
                      value: deleteAfterRing,
                      onChanged: (value) => setState(() {
                            deleteAfterRing = value;
                          })),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

void showLoopModeMenu(TapDownDetails details) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
      details.globalPosition.dx, // Tap's X position
      details.globalPosition.dy, // Tap's Y position
      0, // Distance from the right edge of the screen
      0, // Distance from the bottom edge of the screen
    ),
      items: [
        const PopupMenuItem<String>(
          value: "Once",
          child: Text("Once"),
        ),
        const PopupMenuItem<String>(
          value: "Loop",
          child: Text("Loop"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          // Map the selected string to the corresponding LoopMode
          if (value == "Once") {
            ringtoneLoopMode = LoopMode.off;
          } else if (value == "Loop") {
            ringtoneLoopMode = LoopMode.one;
          }
        });

        // Print the selected LoopMode
        print(ringtoneLoopMode);
      }
    });
  }
  

  _editTitle(BuildContext context) {
  String newSubtitle = ""; // To store the input value
  final formKey = GlobalKey<FormState>(); // Key for validation

  showCupertinoDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Title"),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), // Close dialog
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    size: 24,
                  ),
                ),
              ],
            ),
            content: Material(
              color: Colors.transparent, // Allows the TextFormField to render properly
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Enter new Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        newSubtitle = value.trim();
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text("Confirm"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Update the parent state with the new subtitle
                    this.setState(() {
                      alarmTitle = newSubtitle.trim();
                      noTitle = false;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

}
