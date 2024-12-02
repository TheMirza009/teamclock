import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_slider/Model/Provider%20Classes/theme_class.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_screen.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Hive.initFlutter();
  await Hive.openBox("timezones");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //? HIVE SAVE CHEATSHEET
  // 1 = Timezones
  // 2 = SelectedTimeZonez
  // 3 = ThemeMode
  // 4 = Tasklist
  // 5 = Settings

  @override
  Widget build(BuildContext context) {
    ThemeConstants.screenWidth = MediaQuery.sizeOf(context).width;
    ThemeConstants.screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer(builder: (context, ref, child) {
      HiveFunctions.loadSettings(ref);
      return MaterialApp(
        title: 'Time Slider',
        themeMode: ref.watch(themeProvider), // Riverpod Theme
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
        home: const TimezonesScreen(),
        // home: ItemTraderScreen(),
      );
    });
  }
}
