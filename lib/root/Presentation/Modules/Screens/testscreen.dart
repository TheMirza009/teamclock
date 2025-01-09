import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
              onPressed: () async {
                final currentTime = tz.TZDateTime.now(tz.getLocation("Asia/Karachi"));
                print("Current Time: ${currentTime}");
                var encodedValue = await jsonEncode(currentTime.toString());
                await HiveFunctions.saveData(key: 100, value: encodedValue);
                final loadedValue = await HiveFunctions.readData(key: 100);
                var decodedValue = await jsonDecode(loadedValue);
                final loadedTime = await tz.TZDateTime.parse(tz.getLocation("Asia/Karachi"), decodedValue );
                print("Loaded Time: ${loadedTime}");},
              child: Text("Load Alarms"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:Theme.of(context).colorScheme.surfaceContainer),
              onPressed: () async {
                final time = DateTime.now();
                final tztime = await tz.TZDateTime.now(tz.getLocation("Asia/Karachi"));
                print("Standard: ${time.toString()}");
                print("TZDateTime: ${tztime}");
                print("Location: ${tz.local}");
              },
              child: Text("Print time"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainer),
              onPressed: () async {
                final alarmlist = ref.watch(AlarmStates.alarmsProvider);
                print(alarmlist[0].selectedTime);
              },
              child: Text("Alarm Time Print"),
            ),
          ],
        ),
      ),
    );
  }
}

 loadAndPrintAlarms() async {
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