import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_slider/core/base/controllers/notification_controller.dart';
import 'package:time_slider/core/theme/theme_provider_class.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/timezone_screen.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Hive.initFlutter();
  await Hive.openBox("timezones");
  NotificationController.initializeNotification();

  // Request notification permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }                               
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
  // 2 = Counter
  // 3 = ThemeMode
  // 4 = Tasklist
  // 5 = Alarms
  // 6 = Settings

  @override
  Widget build(BuildContext context) {
    ThemeConstants.screenWidth = MediaQuery.sizeOf(context).width;
    ThemeConstants.screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer(builder: (context, ref, child) {

      // Riverpod-based initializations
      HiveFunctions.loadSettings(ref);
      NotificationController.setListeners(ref);

      // MAIN Material App
      return MaterialApp(
        title: 'Time Slider',
        themeMode: ref.watch(themeProvider), // Riverpod Theme
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
        home: const TimezonesScreen(),
      );
    });
  }
}
