import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Data/models/ringtone_model.dart';
import 'package:time_slider/core/utilities/ringtones_class.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Settings/settings_states.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/ringtone_selection_dialog.dart';
import 'package:time_slider/root/Presentation/Widgets/custom_list_tile.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_functions.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';
import 'package:timezone/timezone.dart' as tz;

// Trigger test
void triggerTest(WidgetRef ref) {
    print("Function 2 called........");
    AlarmFunctions.triggerAlarms(ref);
}

// DEFAULT VALUES DECLARATIONS
final _currentTime = tz.TZDateTime.now(tz.getLocation(TimezoneStates.localTimezoneGlobal));

AlarmItem _defaultAlarm = AlarmItem(
  id: DateTime.now().microsecondsSinceEpoch,
  selectedTime: _currentTime,
  timezone: TimezoneStates.localTimezoneGlobal,
  title: "",
  vibrateOnRing: false,
  deleteAfterRing: false,
  isActive: true,
  isRinging: false,
  ringtone: const Ringtone(
    path: Ringtones.defaultRingtone,
    loop: LoopMode.one,
  ),
);

// MAIN CLASS
class AddAlarmScreen extends ConsumerStatefulWidget {
  final void Function(AlarmItem alarm) onAlarmAdded;
  final AlarmItem? existingAlarm;

  const AddAlarmScreen({
    required this.onAlarmAdded,
    this.existingAlarm,
    super.key,
  });

  @override
  ConsumerState<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends ConsumerState<AddAlarmScreen> {

 void triggerAlarmCallback() {
    print("Function 1 called........");
    AlarmFunctions.triggerAlarms(ref);
  }

  // DECLARATIONS
  late int selectedAmPmIndex; // 0 for AM, 1 for PM
  late int selectedHourIndex;
  late int selectedMinuteIndex;
  late bool vibrateOnRing;
  late bool deleteAfterRing;
  String selectedTimezone = TimezoneStates.localTimezoneGlobal;
  late String ringtonePath;
  late LoopMode ringtoneLoopMode;
  String alarmTitle = "Alarm";

  bool showError = false;
  bool isEmpty = false;
  bool noTitle = false;
  String remainingTimeText = "Alarm sets off in 0 hours, 0 minutes"; // Default text if no time is selected

  // INIT STATE
  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  // FUNCTIONS
  void initializeValues() {

    // Initialize _defaultAlarm with runtime data
    final currentTime = tz.TZDateTime.now(tz.getLocation(TimezoneStates.localTimezoneGlobal));

    // Use the current time to create the default alarm
    _defaultAlarm = AlarmItem(
      id: currentTime.microsecondsSinceEpoch,
      selectedTime: currentTime,
      timezone: selectedTimezone,
      title: alarmTitle,
      vibrateOnRing: false,
      deleteAfterRing: false,
      isActive: true,
      isRinging: false,
      ringtone: const Ringtone(
        path: Ringtones.defaultRingtone,
        loop: LoopMode.one,
      ),
    );

    // Determine the alarm to use, either from widget or default
    final alarm = widget.existingAlarm ?? _defaultAlarm;

    // Initialize state variables from the selected alarm
    selectedAmPmIndex = alarm.selectedTime.hour >= 12 ? 1 : 0; // PM if hour >= 12
    selectedHourIndex = (alarm.selectedTime.hour % 12) == 0  ? 11 : (alarm.selectedTime.hour % 12) - 1; // 0-indexed for picker
    selectedMinuteIndex = alarm.selectedTime.minute;
    vibrateOnRing = alarm.vibrateOnRing;
    deleteAfterRing = alarm.deleteAfterRing;
    selectedTimezone = widget.existingAlarm != null ? alarm.timezone : selectedTimezone;
    ringtonePath = alarm.ringtone.path;
    ringtoneLoopMode = alarm.ringtone.loop;
    alarmTitle = alarm.title;
  }

  // Get selected Time from CUPERTINO PICKERS
  tz.TZDateTime? _getSelectedTime() {
    try {
      // Get the current time in the selected timezone
      final now = tz.TZDateTime.now(tz.getLocation(selectedTimezone));

      // Calculate the selected hour considering AM/PM
      int selectedHour = (selectedHourIndex + 1) % 12 + (selectedAmPmIndex == 1 ? 12 : 0);

      // Create the selected time
      return tz.TZDateTime(
        tz.getLocation(selectedTimezone),
        now.year,
        now.month,
        now.day,
        selectedHour,
        selectedMinuteIndex,
      );
    } catch (e) {
      print("Error in _getSelectedTime: $e");
      return null; // Return null if any error occurs
    }
  }

  // Function to set initial time values based on the current local time
  void setInitialTimeValues() {
    tz.TZDateTime currentTimeLocal = tz.TZDateTime.now(tz.getLocation(selectedTimezone));
    int hour = currentTimeLocal.hour % 12; // Convert to 12-hour format
    selectedAmPmIndex = currentTimeLocal.hour >= 12 ? 1 : 0; // 0 for AM, 1 for PM
    selectedHourIndex = hour == 0 ? 11 : hour - 1; // Index for hour (0 corresponds to 1)
    selectedMinuteIndex = currentTimeLocal.minute; // Index for minutes (0 corresponds to 00)
  }

  Widget _buildCupertinoPicker({
    required int itemCount,
    required int initialItem,
    required ValueChanged<int> onSelectedItemChanged,
    required String Function(int index) itemBuilder,
    bool looping = true,
  }) {
    final displayMedium = GoogleFonts.robotoMono(fontWeight: FontWeight.w300, fontSize: 22);
    return Expanded(
      child: CupertinoPicker(
        looping: looping,
        itemExtent: 60,
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        onSelectedItemChanged: onSelectedItemChanged,
        children: List.generate(
          itemCount,
          (index) => Center(
            child: Text(
              itemBuilder(index),
              style: displayMedium,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showing12HourFormat = ref.watch(SettingsStates.show12HourFormat);
    // selectedTimezone = TimezoneStates.localTimezoneGlobal;
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

                // CLOSE Button
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(
                  children: [

                    // Screen Title 
                    GestureDetector(
                      onTap: () => print(_getSelectedTime()),
                      child: Text(
                        widget.existingAlarm == null ? "Add Alarm" : "Edit Alarm",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),

                    // Dynamically updated time
                    Text(
                      AlarmFunctions.calculateTimeDifference(selectedTimezone, _getSelectedTime()!, showing12HourFormat) ?? remainingTimeText,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                // CONFIRM Button
                IconButton(
                  onPressed: () async {

                    // Main alarm add function
                    tz.TZDateTime? selectedTime = _getSelectedTime();
                    tz.TZDateTime parsedTime = tz.TZDateTime.parse(tz.getLocation(selectedTimezone), selectedTime.toString());
                    final int uniqueID = DateTime.now().millisecondsSinceEpoch % 1000000;
                    final ringtone = Ringtone(path: ringtonePath, loop: ringtoneLoopMode );
                    
                    // Android Alarm Manager state
                    await AndroidAlarmManager.oneShotAt(
                      parsedTime, 
                      uniqueID, 
                      triggerAlarmCallback,
                      exact: true,
                      wakeup: true,
                      );

                    print("New Alarm set with the following parametres. \nTitle: $alarmTitle\nSelected Timezone: $selectedTimezone\nSelected Time: ${selectedTime?.hour} : ${selectedTime?.minute}");

                    if (selectedTime != null) {
                      AlarmItem newAlarm = AlarmItem(
                        id: uniqueID,
                        title: alarmTitle == "" ? "Alarm" : alarmTitle,
                        timezone: selectedTimezone,
                        selectedTime: parsedTime,
                        ringtone: ringtone,
                        deleteAfterRing: deleteAfterRing,
                        vibrateOnRing: vibrateOnRing,
                      );
                      widget.onAlarmAdded(newAlarm);
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

            // Cupertino pickers
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15, left: 30, right: 15),
              child: SizedBox(
                height: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Hours Picker
                    _buildCupertinoPicker(
                      itemCount: showing12HourFormat ? 12 : 24, // 12 for 12-hour, 24 for 24-hour
                      initialItem: selectedHourIndex,
                      onSelectedItemChanged: (index) => setState(() {
                        selectedHourIndex = index;
                      }),
                      itemBuilder: (index) => (showing12HourFormat ? (index + 1) : index).toString().padLeft(2, '0'),
                    ),

                    // Minutes Picker
                    _buildCupertinoPicker(
                      itemCount: 60,
                      initialItem: selectedMinuteIndex,
                      onSelectedItemChanged: (index) => setState(() {
                        selectedMinuteIndex = index;
                      }),
                      itemBuilder: (index) => index.toString().padLeft(2, '0'),
                    ),

                    // AM/PM Picker
                    showing12HourFormat ? _buildCupertinoPicker(
                      itemCount: 2,
                      initialItem: selectedAmPmIndex,
                      looping: false,
                      onSelectedItemChanged: (index) => setState(() {
                        selectedAmPmIndex = index;
                      }),
                      itemBuilder: (index) => index == 0 ? "AM" : "PM",
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // OPTIONS COLUMN
            Column(
              children: [

                // TITLE Option
                CustomListTile(
                  title: "Title",
                  subtitle: noTitle ? "The title cannot be empty."  : alarmTitle,
                  noTitle: noTitle,
                  onTap: () => _editTitle(context),
                ),

                // TIMEZONE Option
                CustomListTile(
                  title: "Timezone",
                  subtitle: TimezoneFunctions.getCityAndCountryFromTimezone(selectedTimezone),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AddTimezoneDialog(
                        addingAlarm: true,
                        onTimezoneAdded: (timezone) {
                          print("SELECTED TIMEZONE FOR ALARM: $timezone");
                          setState(() => selectedTimezone = timezone);
                        },
                      );
                    },
                  ),
                ),

                // RINGTONE Option
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

                // REPEAT Menu
                CustomListTile(
                  title: "Repeat",
                  subtitle: ringtoneLoopMode == LoopMode.off ? "Once" : "Loop",
                  onTapDown: (details) => showLoopModeMenu(details),
                ),

                // VIBRATE option
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

                // DELETE option
                CustomListTile(
                  title: "Delete after ring",
                  subtitle: "",
                  showDivider: false,
                  showChevron: false,
                  trailingWidget: Switch(
                    value: deleteAfterRing,
                    onChanged: (value) => 
                      setState(() => deleteAfterRing = value
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // DIALOGUES for options
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

  // EDIT title
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
                color: Colors
                    .transparent, // Allows the TextFormField to render properly
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
                            return "Alarm";
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
