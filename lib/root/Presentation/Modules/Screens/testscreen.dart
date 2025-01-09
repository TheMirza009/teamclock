import 'dart:async';
import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/core/base/controllers/notification_controller.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_functions.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Settings/settings_states.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

testPrint() {
  print("NOTIFY");
}

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  bool showing12HourFormat = true;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    // Simulate a data loading operation
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Perform any required periodic update here
      });
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: !showing12HourFormat),
          child: child!,
        );
      },
    );

     if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });

      if (_selectedDateTime != null) {
        print("Scheduling alarm at: $_selectedDateTime");
        AndroidAlarmManager.oneShotAt(_selectedDateTime!, 001, NotificationController.showTestNotification);
      } else {
        print("The selected time is in the past or too close.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    showing12HourFormat = ref.watch(SettingsStates.show12HourFormat);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                _selectedDateTime != null
                    ? "Selected DateTime: ${_selectedDateTime!.toLocal()}"
                    : "No time selected",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            if (_selectedDateTime != null) // Null check for safe use
              Text("Remaining time: ${_selectedDateTime!.toLocal().difference(DateTime.now()).inSeconds}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showTimePicker(context),
              child: const Text("Pick a Time"),
            ),
            ElevatedButton(
              onPressed: () => AndroidAlarmManager.oneShot(const Duration(seconds: 0), 001, NotificationController.showTestNotification),
              child: const Text("Shoot notification"),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> loadAndPrintAlarms() async {
  var storedValue = await HiveFunctions.readData(key: 5);

  if (storedValue != null) {
    // Decode the JSON data into a list of maps
    List<dynamic> jsonList = jsonDecode(storedValue);

    // Deserialize JSON into AlarmItem objects
    List<AlarmItem> alarmList = jsonList.map((json) {
      final timezone = json['timezone'];
      final selectedTimeString = json['selectedTime'];
      final DateTime utcTime = DateTime.parse(selectedTimeString);
      final loadedSelectedTime = tz.TZDateTime.from(
        utcTime,
        tz.getLocation(timezone),
      );

      final AlarmItem alarm = AlarmItem(
        id: json['id'],
        title: json['title'],
        timezone: timezone,
        selectedTime: loadedSelectedTime,
        isRinging: json['isRinging'] ?? false,
        isActive: json['isActive'] ?? true,
      );

      print("Title: ${alarm.title}, Timezone: ${alarm.timezone}, Time: ${alarm.selectedTime}");
      return alarm;
    }).toList();

    // Update the provider with the loaded alarms
  }
}
