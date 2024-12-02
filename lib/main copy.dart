// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:time_slider/Model/Provider%20Classes/theme_class.dart';
// import 'package:time_slider/Model/hive_class.dart';
// import 'package:time_slider/View/Screens/timezone_screen.dart';
// import 'package:time_slider/View/Screens/pomodoro_screen.dart';
// import 'package:time_slider/View/Theme/themeconstants.dart';
// import 'package:time_slider/View/Utils/Pomodoro%20Components/Main%20Riverpod%20Version/pomodoro_widget_riverpod.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones();
//   await Hive.initFlutter();
//   await Hive.openBox("timezones");
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   ThemeMode _themeMode = ThemeMode.system;

//   //? HIVE SAVE CHEATSHEET

//   // 1 = Timezones
//   // 2 = SelectedTimeZone
//   // 3 = ThemeMode

//   // Function to handle theme mode change
//   void _handleThemeChange(ThemeMode themeMode) async {
//     setState(() {
//       _themeMode = themeMode; // Update the theme mode based on user selection
//     });
//     await HiveFunctions.saveThemeMode(themeMode);
//   }

//   // Initialize the theme from Hive
//   // Future<void> _initializeTheme() async {
//   //   final themedata = await HiveFunctions.loadThemeMode();
//   //   setState(() {
//   //     _themeMode = themedata ?? ThemeMode.system;
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initializeTheme(); // Load the theme mode from Hive
//   // }

//   @override
// Widget build(BuildContext context) {
//   ThemeConstants.screenWidth = MediaQuery.sizeOf(context).width;
//   ThemeConstants.screenHeight = MediaQuery.sizeOf(context).height;
//   return Consumer(
//     builder: (context, ref, child) {
//       return MaterialApp(
//         title: 'Time Slider',
//         // themeMode: _themeMode,  // Ensure this is updated on theme change
//         themeMode: ref.watch(themeProvider),  // Ensure this is updated on theme change
//         theme: ThemeConstants.lightTheme,
//         darkTheme: ThemeConstants.darkTheme,
//         home: TimezonesScreen(
//             title: 'Time Slider',
//             onThemeChanged: _handleThemeChange,
//             ),
//       );
//     }
//   );
// }

// }
