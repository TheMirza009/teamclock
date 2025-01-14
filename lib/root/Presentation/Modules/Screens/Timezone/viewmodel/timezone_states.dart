import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';

class TimezoneStates {
  static bool isLoading = false;
  static String localTimezoneGlobal = "UTC";
  static String selectedTimeZone = "UTC";
  static List<String> timezoneselections = [];

  // Async method to fetch and set the local timezone
  static Future<void> initializeTimeZone() async {
    String localTimezone = await FlutterTimezone.getLocalTimezone();
    if (!timezoneselections.contains(localTimezone)) timezoneselections.add(localTimezone);
    selectedTimeZone = localTimezone;
    TimezoneStates.localTimezoneGlobal = localTimezone;
    await HiveFunctions.saveTimeZones(selectedTimeZone: selectedTimeZone, timezoneList: timezoneselections);
  }
}