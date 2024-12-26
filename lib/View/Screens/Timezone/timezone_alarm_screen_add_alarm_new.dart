// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:time_slider/Model/Models/alarm_item.dart';
// import 'package:time_slider/Model/Models/ringtone_model.dart';
// import 'package:time_slider/Model/ringtones_class.dart';
// import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
// import 'package:time_slider/View/Utils/Dialogues/ringtone_selection_dialog.dart';
// import 'package:time_slider/View/Utils/custom_list_tile.dart';
// import 'package:time_slider/ViewModel/alarm_functions.dart';
// import 'package:time_slider/ViewModel/timezone_functions.dart';
// import 'package:timezone/timezone.dart' as tz;

// final AlarmItem _defaultAlarm = AlarmItem(
//   id: DateTime.now().microsecondsSinceEpoch,
//   selectedTime: tz.TZDateTime.now(tz.local),
//   timezone: 'Asia/Karachi',
//   title: "",
//   vibrateOnRing: false,
//   deleteAfterRing: false,
//   isActive: true,
//   isRinging: false,
//   ringtone: const Ringtone(
//     path: Ringtones.defaultRingtone,
//     loop: LoopMode.one,
//   ),
// );

// class AddAlarmScreen extends StatefulWidget {
//   final void Function(AlarmItem alarm) onAlarmAdded;
//   final AlarmItem? existingAlarm;

//   const AddAlarmScreen({
//     required this.onAlarmAdded,
//     this.existingAlarm,
//     super.key,
//   });

//   @override
//   State<AddAlarmScreen> createState() => _AddAlarmScreenState();
// }

// class _AddAlarmScreenState extends State<AddAlarmScreen> {
//   late int selectedAmPmIndex; // 0 for AM, 1 for PM
//   late int selectedHourIndex;
//   late int selectedMinuteIndex;
//   late bool vibrateOnRing;
//   late bool deleteAfterRing;
//   late String selectedTimezone;
//   late String ringtonePath;
//   late LoopMode ringtoneLoopMode;
//   late String alarmTitle;
//   bool showError = false;

//   bool isEmpty = false;
//   bool noTitle = false;
//   String remainingTimeText = "Alarm sets off in 0 hours, 0 minutes"; // Default text if no time is selected

//   @override
//   void initState() {
//     super.initState();
//     final alarm = widget.existingAlarm ?? _defaultAlarm;

//     selectedAmPmIndex = alarm.selectedTime.hour >= 12 ? 1 : 0; // PM if hour >= 12
//     selectedHourIndex = (alarm.selectedTime.hour % 12) == 0 ? 11 : (alarm.selectedTime.hour % 12) - 1; // 0-indexed for picker
//     selectedMinuteIndex = alarm.selectedTime.minute;
//     vibrateOnRing = alarm.vibrateOnRing;
//     deleteAfterRing = alarm.deleteAfterRing;
//     selectedTimezone = alarm.timezone;
//     ringtonePath = alarm.ringtone.path;
//     ringtoneLoopMode = alarm.ringtone.loop;
//     alarmTitle = alarm.title;
//   }

//   tz.TZDateTime? _getSelectedTime() {
//     final now = tz.TZDateTime.now(tz.local);
//     int selectedHour = (selectedHourIndex + 1) % 12 + (selectedAmPmIndex == 1 ? 12 : 0);
//     return tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       selectedHour,
//       selectedMinuteIndex,
//     );
//   }

//   void _addAlarm() {
//     final selectedTime = _getSelectedTime();
//     if (selectedTime != null && alarmTitle.trim().isNotEmpty) {
//       widget.onAlarmAdded(
//         AlarmItem(
//           id: DateTime.now().microsecondsSinceEpoch,
//           title: alarmTitle,
//           timezone: selectedTimezone,
//           selectedTime: selectedTime,
//           ringtone: Ringtone(path: ringtonePath, loop: ringtoneLoopMode),
//           deleteAfterRing: deleteAfterRing,
//           vibrateOnRing: vibrateOnRing,
//         ),
//       );
//       Navigator.pop(context);
//     } else {
//       setState(() => showError = true);
//       Future.delayed(const Duration(seconds: 2), () => setState(() => showError = false));
//     }
//   }

//   Widget _buildPicker({
//     required int itemCount,
//     required String Function(int) labelBuilder,
//     required ValueChanged<int> onSelectedItemChanged,
//   }) {
//     return Expanded(
//       child: CupertinoPicker(
//         itemExtent: 60,
//         looping: true,
//         onSelectedItemChanged: onSelectedItemChanged,
//         children: List.generate(
//           itemCount,
//           (index) => Center(
//             child: Text(
//               labelBuilder(index),
//               style: GoogleFonts.robotoMono(fontSize: 22, fontWeight: FontWeight.w300),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _editTitle(BuildContext context) {
//   String newSubtitle = ""; // To store the input value
//   final formKey = GlobalKey<FormState>(); // Key for validation

//   showCupertinoDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return CupertinoAlertDialog(
//             title: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Title"),
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(), // Close dialog
//                   icon: const Icon(
//                     CupertinoIcons.xmark,
//                     size: 24,
//                   ),
//                 ),
//               ],
//             ),
//             content: Material(
//               color: Colors.transparent, // Allows the TextFormField to render properly
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       autofocus: true,
//                       decoration: InputDecoration(
//                         labelText: "Enter new Title",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Title cannot be empty";
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         newSubtitle = value.trim();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 isDestructiveAction: true,
//                 child: const Text("Cancel"),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               CupertinoDialogAction(
//                 child: const Text("Confirm"),
//                 onPressed: () {
//                   if (formKey.currentState!.validate()) {
//                     // Update the parent state with the new subtitle
//                     this.setState(() {
//                       alarmTitle = newSubtitle.trim();
//                       noTitle = false;
//                     });
//                     Navigator.of(context).pop();
//                   }
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

//   void showLoopModeMenu(TapDownDetails details) {
//     showMenu<String>(
//       context: context,
//       position: RelativeRect.fromLTRB(
//         details.globalPosition.dx, // Tap's X position
//         details.globalPosition.dy, // Tap's Y position
//         0, // Distance from the right edge of the screen
//         0, // Distance from the bottom edge of the screen
//       ),
//       items: const [
//         PopupMenuItem<String>(
//           value: "Once",
//           child: Text("Once"),
//         ),
//         PopupMenuItem<String>(
//           value: "Loop",
//           child: Text("Loop"),
//         ),
//       ],
//     ).then((value) {
//       if (value != null) {
//         setState(() {
//           ringtoneLoopMode = value == "Once" ? LoopMode.off : LoopMode.one;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//              // TOP SECTION
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close, size: 30),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 Column(
//                   children: [
//                     const Text(
//                       "Add Alarm",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     Text(
//                       AlarmFunctions.calculateTimeDifference(selectedTimezone, _getSelectedTime()!) ?? remainingTimeText, // Dynamically updated text
//                       style: const TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     tz.TZDateTime? selectedTime = _getSelectedTime();
//                     final ringtone = Ringtone(path: ringtonePath, loop: ringtoneLoopMode );

//                     print("New Alarm set with the following parametres. \nTitle: $alarmTitle\nSelected Timezone: $selectedTimezone\nSelected Time: ${selectedTime?.hour} : ${selectedTime?.minute}");

//                     if (selectedTime != null && alarmTitle != "") {
//                       AlarmItem newAlarm = AlarmItem(
//                         id: DateTime.now().microsecondsSinceEpoch,
//                         title: alarmTitle,
//                         timezone: selectedTimezone,
//                         selectedTime: selectedTime,
//                         ringtone: ringtone,
//                         deleteAfterRing: deleteAfterRing,
//                         vibrateOnRing: vibrateOnRing,
//                       );
//                       widget.onAlarmAdded(newAlarm);
//                       Navigator.pop(context);
//                     } else {
//                       setState(() {
//                         isEmpty = true;
//                         noTitle = true;
//                       });
//                       Future.delayed(const Duration(seconds: 2), () {
//                         setState(() {
//                           isEmpty = false;
//                         });
//                       });
//                     }
//                   },
//                   icon: const Icon(Icons.check, size: 30),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 300,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildPicker(
//                     itemCount: 12,
//                     labelBuilder: (index) => (index + 1).toString().padLeft(2, '0'),
//                     onSelectedItemChanged: (index) => setState(() => selectedHourIndex = index),
//                   ),
//                   _buildPicker(
//                     itemCount: 60,
//                     TimezoneFunctions (index) => index.toString().padLeft(2, '0'),
//                     onSelectedItemChanged: (index) => setState(() => selectedMinuteIndex = index),
//                   ),
//                   _buildPicker(
//                     itemCount: 2,
//                     labelBuilder: (index) => index == 0 ? "AM" : "PM",
//                     onSelectedItemChanged: (index) => setState(() => selectedAmPmIndex = index),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 CustomListTile(
//                   title: "Title",
//                   subtitle: alarmTitle.isEmpty ? "No title set" : alarmTitle,
//                   noTitle:  alarmTitle.isEmpty,
//                   onTap: () => _editTitle(context),
//                 ),
//                 CustomListTile(
//                   title: "Timezone",
//                   subtitle: TimeFunctions.getCityAndCountryFromTimezone(selectedTimezone),
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AddTimezoneDialog(
//                         onTimezoneAdded: (timezone) {
//                           setState(() => selectedTimezone = timezone);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 CustomListTile(
//                   title: "Ringtone",
//                   subtitle:  Ringtones.extractTitle(ringtonePath),
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (context) {
//                       return RingtoneSelectionDialog(
//                         onRingtoneSelected: (selectedRingtone) {
//                           setState(() {
//                             ringtonePath = selectedRingtone;
//                           });
//                           print("Selected Ringtone: $selectedRingtone");
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 CustomListTile(
//                   title: "Repeat",
//                   subtitle: ringtoneLoopMode == LoopMode.off ? "Once" : "Loop",
//                   onTapDown: (details) => showLoopModeMenu(details),
//                 ),
//                 CustomListTile(
//                   title: "Vibrate on ring",
//                   subtitle: "",
//                   showChevron: false,
//                   trailingWidget: Switch(
//                     value: vibrateOnRing,
//                     onChanged: (value) {
//                       setState(() {
//                         vibrateOnRing = value;
//                       });
//                     }),
//                 ),
//                 CustomListTile(
//                   title: "Delete after ring",
//                   subtitle: "",
//                   showDivider: false,
//                   showChevron: false,
//                   trailingWidget: Switch(
//                     value: deleteAfterRing,
//                     onChanged: (value) => setState(
//                       () => deleteAfterRing = value,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
