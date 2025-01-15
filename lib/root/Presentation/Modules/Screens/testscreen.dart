import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_ring.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Settings/settings_states.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

ReceivePort? globalReceivePort;

testPrint() {
  print(AlarmStates.alarmList.length);
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

    // Initialize the ReceivePort if not already initialized
    if (globalReceivePort == null) {
      globalReceivePort = ReceivePort();
      globalReceivePort!.listen((message) {
        print("Received message: $message");
        if (message is Map<String, dynamic>) {
          final alarmId = message['id'];
          print("Alarm with ID $alarmId was triggered.");
        }
      });
    }
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
        var alarms = ref.watch(AlarmStates.alarmsProvider);
        print("Scheduling alarm at: $_selectedDateTime");
        // AndroidAlarmManager.oneShotAt(_selectedDateTime!, 001, NotificationController.showTestNotification);
        AndroidAlarmManager.oneShotAt(_selectedDateTime!, alarms[0].id, testPrint);
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
              onPressed: () {
                print("SEND ACTION PRESSED");
                if (globalReceivePort != null) {
                  final sendPort = globalReceivePort!
                      .sendPort; // Correctly access the sendPort
                  sendPort.send({'id': 001}); // Send a test message
                } else {
                  print("ReceivePort is not initialized.");
                }
              },
              child: const Text("Pick a Time"),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterRingtonePlayer().play(
                  android: AndroidSounds.alarm,
                  ios: IosSounds.glass,
                  asAlarm: true,
                );
              },
              child: const Text("Shoot notification"),
            ),
            ElevatedButton(
              onPressed: () async {
                var alarms = ref.watch(AlarmStates.alarmsProvider);
                if (alarms.isNotEmpty) {
                  final AlarmItem alarm = alarms[0]; 
                  final selectedTime = alarm.selectedTime.toUtc();
                  await AndroidAlarmManager.oneShotAt(
                    selectedTime,
                    alarm.id,
                    AlarmRing.printAlarmDetails,
                    params: alarm.toJson(),
                      
                    exact: true,
                    alarmClock: true,
                    wakeup: true,
                    allowWhileIdle: true,
                  );
                  print("Android Alarm Manager called for \n>>Title: ${alarm.title}\n>>Timezone: ${alarm.timezone}\n>>Time: ${alarm.selectedTime.hour}:${alarm.selectedTime.minute}");
                } else {
                  print("No alarms available to trigger.");
                }
              },
              child: const Text("Test Print"),
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


// var alarmsNotifier = ref.read(AlarmStates.alarmsProvider.notifier);
        // var alarms = alarmsNotifier.state;

        // // Find the alarm by ID and toggle its isRinging value
        // for (var alarm in alarms) {
        //   if (alarm.id == alarmId) {
        //     alarm.isRinging = !alarm.isRinging;
        //     break; // Exit the loop once the alarm is found
        //   }
        // }
        // alarmsNotifier.state = alarms;