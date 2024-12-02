import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_slider/Model/pomodoro_states.dart';
import 'package:time_slider/Model/settings_states.dart';

class HiveFunctions {

  //? HIVE SAVE CHEATSHEET
  // 1 = Timezones
  // 2 = Counter
  // 3 = ThemeMode
  // 4 = Tasklist
  // 5 = Settings
  
  // Write Data
  static Future saveData({key, value}) async {
    final timebox = Hive.box("timezones");
    await timebox.put(key, value);
  } 

  // Read Data
  static readData({key}) async {
    final timebox = Hive.box("timezones");
    final data = await timebox.get(key);
    return data;
  } 

  // Delete Data
  static void deleteData({key}) async {
    final timebox = Hive.box("timezones");
    await timebox.delete(key);
  } 

  // Clear Data
  static void clearAlldata() async {
    final timebox = Hive.box("timezones");
    await timebox.clear();
    print("All data cleared.");
  } 

  // TimeZone Saving function
  static Future<void> saveTimeZones({
    required String selectedTimeZone,
    required List<String> timezoneList,
  }) async {
    try {
      final timebox = await Hive.openBox("timezones");

      // Create a Map to store selected timezone and the list of timezones
      Map<String, dynamic> data = {
        'selectedtimezone': selectedTimeZone,
        'timezoneselections': timezoneList,
      };
      await timebox.put(1, data); // Store data with key '1'
      print("Data saved successfully");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  //? THEME SAVE FUNCTIONS
  // Function to save theme mode as integer
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    await saveData(key: 3, value: themeMode.index);
  }

  // Function to load theme mode from integer
  static Future<ThemeMode?> loadThemeMode() async {
    var storedValue = await readData(key: 3);
    if (storedValue != null) {
      return ThemeMode.values[storedValue];
    }
    return null;
  }

  //? SETTINGS SAVE FUNCTIONS
  // Function to save seconds shown
  static Future<void> saveSettings(WidgetRef ref) async {
    final showSeconds = ref.watch(SettingsStates.showSeconds);
    final show12HourFormat = ref.watch(SettingsStates.show12HourFormat);
    final timeDurations = ref.watch(PomodoroStates.timerDurationsNotifierProvider);
    final settings = [  showSeconds, show12HourFormat, timeDurations ];
    await saveData(key: 5, value: settings);
    print("Saved Settings: \n=>Show Seconds:  ${settings[0]} \n=>Show 12-Hour format: ${settings[1]} \n=>Time Durations map: ${settings[2]} ");
  }

  // Function to load settings
  static Future<void> loadSettings(WidgetRef ref) async {
  final storedSettings = await readData(key: 5);

  if (storedSettings != null) {
    ref.read(SettingsStates.showSeconds.notifier).state = storedSettings[0] ?? false;
    ref.read(SettingsStates.show12HourFormat.notifier).state = storedSettings[1] ?? true;

    // Safely convert storedSettings[2] to Map<int, int>
    if (storedSettings[2] is Map) {
      final updatedDurations = (storedSettings[2] as Map).map(
        (key, value) => MapEntry<int, int>(key as int, value as int),
      );
      ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).updateAllDurations(updatedDurations);
      SettingsStates.initialDurations = updatedDurations; // Sync with initial durations
    } else {
      ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetToDefault(ref);
    }
  } else {
    // Apply default values if no stored settings
    ref.read(SettingsStates.showSeconds.notifier).state = false;
    ref.read(SettingsStates.show12HourFormat.notifier).state = true;
    ref.read(PomodoroStates.timerDurationsNotifierProvider.notifier).resetToDefault(ref);
  }

  print("LOADED Settings: \n=>Show Seconds:  ${storedSettings[0]} \n=>Show 12-Hour format: ${storedSettings[1]} \n=>Time Durations map: ${storedSettings[2]} ");

}



}