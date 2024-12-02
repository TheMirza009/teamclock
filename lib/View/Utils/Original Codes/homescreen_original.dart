// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:time_slider/Model/states.dart';
// import 'package:time_slider/View/Utils/Dialogues/addtimezone_dialog.dart';
// import 'package:time_slider/View/Utils/Dialogues/themeselection_dialog.dart';
// import 'package:time_slider/View/Utils/timezoneUI.dart';
// import 'package:time_slider/View/Utils/timezoneminiwidget.dart';
// import 'package:time_slider/View/Utils/timezonewidget.dart';
// import 'package:time_slider/ViewModel/timefunctions.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:time_slider/Model/timezone.dart';
// import 'package:time_slider/View/Theme/themeconstants.dart';
// import 'package:wheel_slider/wheel_slider.dart';
// import 'dart:math' as math;

// class HomeScreen extends StatefulWidget {
//   static bool isDark = false;
//   static ThemeMode thememode = ThemeMode.system;
//   const HomeScreen.HomeScreen({
//     super.key,
//     required this.title,
//     required this.onThemeChanged,
//   });
//   final String title;
//    final ValueChanged<ThemeMode> onThemeChanged; // Callback to update theme mod

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int counter = 0;
//   late Timer _timer; // Declare the Timer
//   late String selectedTimeZone;
//   // ThemeMode _themeMode = ThemeMode.system;
//   // DateTime currentTime = DateTime.now(); // Store current time

//   @override
//   void initState() {
//     super.initState();
//     final location = tz.local; 
//     selectedTimeZone = location.name;
//     _startTimer(); // Start the timer when the widget is initialized
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }

//   void _incrementCounter() async {
//     setState(() {
//       // counter++;
//     });
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AddTimezoneDialog();
//         });
//   }

//   String formatCounter(int counter) {
//     String sign = counter >= 0 ? '+' : '-';
//     int absCounter = counter.abs();

//     int hours = absCounter ~/ 60;
//     int minutes = absCounter % 60;

//     return hours + minutes == 0
//         ? ""
//         : (hours > 0
//             ? '${sign}${hours}h${minutes > 0 ? ', ${minutes}m' : ''}'
//             : '${sign}${minutes}m');
//   }

//     String getTimeZone() {
//     // Get the local time zone offset
//     Duration offset = DateTime.now().timeZoneOffset;
//     String timeZone = offset.isNegative ? '-' : '+';

//     // Format the offset to match the HH:mm pattern
//     timeZone +=
//         '${offset.inHours.abs().toString().padLeft(2, '0')}:${(offset.inMinutes.abs() % 60).toString().padLeft(2, '0')}';

//     return 'UTC$timeZone'; // e.g., "UTC+05:00"
//   }


//   @override
//   Widget build(BuildContext context) {
//     // selectedTimeZone = tz.local.name;
//     // Drawer Custom icon
//     final drawerIconButton = Builder(
//       builder: (context) {
//         return IconButton(
//           onPressed: () => Scaffold.of(context).openDrawer(),
//           icon: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: SvgPicture.asset(
//               "Assets/icons/Menubars.svg",
//               color: Theme.of(context).colorScheme.onSecondary,
//               height: 10,
//             ),
//           ),
//         );
//       },
//     );
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: drawerIconButton,
//         actions: [
//           // Switch(
//           //   value: HomeScreen.isDark,
//           //   onChanged: (value) {
//           //     setState(() {
//           //       HomeScreen.isDark = value;
//           //     });
//           //     widget.onThemeChanged(value);
//           //   },
//           // ),
//           IconButton(onPressed: () {
//                 // Show the theme selection dialog
//                 showDialog(
//                   context: context,
//                   builder: (context) => ThemeSelectionDialog(
//                     onThemeChanged: (themeMode) {
//                       // Pass the selected theme mode back to MyApp
//                       widget.onThemeChanged(themeMode);
//                     },
//                   ),
//                 );
//               }, icon: Icon(Icons.light_mode, color: ThemeConstants.neutralgrey,))
//         ],
//       ),
//       drawer: const Drawer(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 TimeZoneMainUI(
//                   selectedTimeZone: selectedTimeZone,
//                   counter: counter,
//                   slider: Slider(
//                     max: 1440,
//                     min: -1440,
//                     value: counter.toDouble(),
//                     onChanged: (value) {
//                       setState(() {
//                         // Update the state with the new value
//                         counter = value.toInt();
//                       });
//                     },
//                   ),
//                   onResetPressed: () => setState(() {
//                     counter = 0;
//                   }),
//                 ),
//                 // Main Timezone widget
//                 // TimeZoneWidget(
//                 //   timezone: selectedTimeZone,
//                 // ),
//                 // Transform.rotate(
//                 //   angle: -math.pi / 1.0,
//                 //   child: WheelSlider(
//                 //     lineColor: Theme.of(context).colorScheme.primary,
//                 //     pointerColor: Colors.transparent,
//                 //     totalCount: 2880, // Adjusted for -1440 to 1440
//                 //     initValue: 1440, // Start at 0 (or 1440 to represent -1440)
//                 //     scrollPhysics: const BouncingScrollPhysics(),
//                 //     onValueChanged: (val) {
//                 //      setState(() {
//                 //         // Convert the value to the desired range
//                 //         counter = val -
//                 //             1440; // Shift the range from 0-2880 to -1440 to 1440
//                 //       });
//                 //     },
//                 //     hapticFeedbackType: HapticFeedbackType.vibrate,
//                 //   ),
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     // Conditional Rendering of the RESET BUTTON
//                 //     counter == 0
//                 //         ? const SizedBox(height: 40)
//                 //         : IconButton.outlined(
//                 //             onPressed: () => setState(() {
//                 //               counter = 0;
//                 //             }),
//                 //             icon: Icon(
//                 //               Icons.refresh,
//                 //               color: Theme.of(context).colorScheme.primary,
//                 //             ),
//                 //           ),
//                 //   ],
//                 // ),
//                 // Text(
//                 //   '${formatCounter(counter)}',
//                 //   style: Theme.of(context).textTheme.headlineMedium,
//                 // ),
//                 Column(
//                       children: States.timezoneselections.map((timezone) {
//                         return GestureDetector(
//                           onTap: () {
//                              setState(() {
//                               selectedTimeZone = timezone;
//                           });
//                         },
//                           child: TimeZoneMiniWidget(
//                             isSelected: selectedTimeZone == timezone,
//                             dynamicMinutes: counter,
//                             timezone: timezone,
//                             selectedTimeZone: selectedTimeZone,
//                             onDeletePressed: () {
//                               setState(() {
//                                 States.timezoneselections.remove(timezone);
//                               });
//                             },
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     TextButton(
//                   onPressed: _incrementCounter,
//                   child: Center(
//                     child: Text(
//                       "+ Add Timezone",
//                       style: GoogleFonts.montserrat(
//                         fontSize: ThemeConstants.getDynamicFontSize(17),
//                         color: Theme.of(context).colorScheme.onSecondary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                     SizedBox(height: 30,),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ),
//     );
//   }
// }

// floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//          final data = await HiveFunctions.readData(key: 2);
//          final timedata = await HiveFunctions.readData(key: 1);
//          setState(() {
//            counter = data;
//            States.selectedTimeZone = timedata['selectedtimezone'];
//            States.timezoneselections = timedata['timezoneselections'];
//          });
//         },
//         tooltip: 'Save Timezones',
//         child: const Icon(Icons.save),
//       ),
