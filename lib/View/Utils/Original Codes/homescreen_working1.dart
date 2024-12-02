// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:time_slider/Model/hive_class.dart';
// import 'package:time_slider/Model/states.dart';
// import 'package:time_slider/View/Utils/Dialogues/addtimezone_dialog.dart';
// import 'package:time_slider/View/Utils/Dialogues/themeselection_dialog_ios.dart';
// import 'package:time_slider/View/Utils/timezoneUI.dart';
// import 'package:time_slider/View/Utils/timezoneminiwidget.dart';
// import 'package:time_slider/View/Theme/themeconstants.dart';

// class HomeScreen extends StatefulWidget {
//   static bool isDark = false;
//   static ThemeMode thememode = ThemeMode.system;
//   const HomeScreen.HomeScreen({
//     super.key,
//     required this.title,
//     required this.onThemeChanged,
//   });
//   final String title;
//   final ValueChanged<ThemeMode> onThemeChanged; // Callback to update theme mod

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int counter = 0;
//   late Timer _timer; // Declare the Timer
//   // ThemeMode _themeMode = ThemeMode.system;
//   // DateTime currentTime = DateTime.now(); // Store current time

//   @override
//   void initState() {
//     super.initState();
//     _initializeHive();
//     _startTimer(); // Start the timer when the widget is initialized
//   }

//   Future<void> _initializeHive() async {
//     States.isLoading = true;
//     await Hive.openBox('timezones'); // Open the box

//     // Load and Assign
//     final loadednumber = await HiveFunctions.readData(key: 2);
//     final timezonedata = await HiveFunctions.readData(key: 1);
//     setState(() {
//       counter = loadednumber;
//       States.selectedTimeZone = timezonedata['selectedtimezone'];
//       States.timezoneselections = timezonedata['timezoneselections'];
//       States.isLoading = false;
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() async {
//     _timer.cancel(); // Cancel the timer when the widget is disposed
//     await Hive.close();
//     super.dispose();
//   }

//   void _incrementCounter() async {
//     setState(() {
//       // counter++;
//     });
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const AddTimezoneDialog();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeContext = Theme.of(context);
//     final isDark = themeContext.brightness == Brightness.dark;
//     final primaryColor = themeContext.colorScheme.primary;

//     // Drawer Custom icon
//     final drawerIconButton = Builder(
//       builder: (context) {
//         return IconButton(
//           onPressed: () => Scaffold.of(context).openDrawer(),
//           icon: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: SvgPicture.asset(
//               "Assets/icons/Menubars.svg",
//               color: Theme.of(context).colorScheme.primary,
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
//           IconButton(
//             onPressed: () {
//               // Show the theme selection dialog
//               showCupertinoModalPopup(
//                 context: context,
//                 builder: (context) => ThemeSelectionDialogIOS(
//                   onThemeChanged: (themeMode) {
//                     // Pass the selected theme mode back to MyApp
//                     widget.onThemeChanged(themeMode);
//                   },
//                 ),
//               );
//             },
//             icon: isDark
//                 ? Icon(Icons.dark_mode, color: primaryColor)
//                 : Icon(Icons.light_mode, color: primaryColor),
//           )
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
//                   selectedTimeZone: States.selectedTimeZone,
//                   counter: counter,
//                   slider: Slider(
//                     max: 1440,
//                     min: -1440,
//                     value: counter.toDouble(),
//                     onChanged: (value) async {
//                       setState(() {
//                         // Update the state with the new value
//                         counter = value.toInt();
//                       });
//                       final timebox = Hive.box("timezones");
//                       await timebox.put(2, counter);
//                     },
//                   ),
//                   onResetPressed: () async => setState(() {
//                     counter = 0;
//                     HiveFunctions.saveData(key: 2, value: counter);
//                   }),
//                 ),

//                 // Conditional Loading
//                 States.isLoading
//                     ? const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(30.0),
//                           child: SizedBox(
//                             height: 30,
//                             width: 30,
//                             child: CircularProgressIndicator()),
//                         ),
//                       )
//                     : Column(
//                         children: States.timezoneselections.map((timezone) {
//                           return GestureDetector(
//                       onTap: () async {
//                         setState(() {
//                           States.selectedTimeZone = timezone;
//                         });
//                           await HiveFunctions.saveTimeZones(selectedTimeZone: States.selectedTimeZone, timezoneList: States.timezoneselections,);
//                       },
//                       child: TimeZoneMiniWidget(
//                         isSelected: States.selectedTimeZone == timezone,
//                         dynamicMinutes: counter,
//                         timezone: timezone,
//                         selectedTimeZone: States.selectedTimeZone,
//                         onDeletePressed: () {
//                           setState(() {
//                             States.timezoneselections.remove(timezone);
//                           });
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 TextButton(
//                   onPressed: _incrementCounter,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "+ Add Timezone",
//                         style: GoogleFonts.montserrat(
//                           fontSize: ThemeConstants.getDynamicFontSize(17),
//                           color: Theme.of(context).colorScheme.onSecondary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
