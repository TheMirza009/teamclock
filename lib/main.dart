import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teamclock/core/base/controllers/notification_controller.dart';
import 'package:teamclock/core/base/controllers/port_controller.dart';
import 'package:teamclock/core/theme/theme_provider_class.dart';
import 'package:teamclock/core/base/controllers/hive_class.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/homescreen.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetbinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetbinding);
  tz.initializeTimeZones();
  await Hive.initFlutter();
  await Hive.openBox("timezones");
  AndroidAlarmManager.initialize();
  NotificationController.initializeNotification();

  //? TO-DO :
  //> Perfection remains

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
  static const platform = MethodChannel('com.team.teamclock/navigation');

  //? HIVE SAVE CHEATSHEET
  // 1 = Timezones
  // 2 = Counter
  // 3 = ThemeMode
  // 4 = Tasklist
  // 5 = Alarms
  // 6 = Settings

  @override
  void initState() {
    super.initState();
    endSplash();
    NotificationController.onColdStart();
  }

  void endSplash() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    ThemeConstants.screenWidth = MediaQuery.sizeOf(context).width;
    ThemeConstants.screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer(builder: (context, ref, child) {

      // Riverpod-based initializations
      HiveFunctions.loadSettings(ref);
      HiveFunctions.loadAlarms(ref);
      NotificationController.setListeners(ref);

      // MAIN Material App
      return MaterialApp(
        title: 'Teamclock',
        themeMode: ref.watch(themeProvider), // Riverpod Theme
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
        navigatorKey: navigatorKey,
        home: const Homescreen(),
        // home: const TimezonesScreen(),
      );
    });
  }
}
