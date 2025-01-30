import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teamclock/core/base/controllers/notification_controller.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Data/models/alarm_item.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_functions.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class PortTestScreen extends ConsumerStatefulWidget {
  const PortTestScreen({super.key});

  @override
  _PortTestScreenState createState() => _PortTestScreenState();
}

class _PortTestScreenState extends ConsumerState<PortTestScreen> {
  static ReceivePort? globalReceivePort;
  static SendPort? globalSendPort;

  @override
  void initState() {
    super.initState();
    _initializeGlobalReceivePort();
  }

  /// Initializes the global ReceivePort
  void _initializeGlobalReceivePort() async {
    List<AlarmItem> alarms = ref.watch(AlarmStates.alarmsProvider);
    if (globalReceivePort == null) {
      globalReceivePort = ReceivePort();
      globalReceivePort!.listen((message) async {
        AlarmItem alarm = alarms.firstWhere((alarm) => alarm.id == message['id']);
        alarm.isRinging = true;
        print("RECEIVED MESSAGE: $message");
      });

      globalSendPort = globalReceivePort!.sendPort;

      // Register the SendPort with IsolateNameServer
      IsolateNameServer.removePortNameMapping('globalSendPort');
      IsolateNameServer.registerPortWithName(globalSendPort!, 'globalSendPort');
      print("Global SendPort registered with IsolateNameServer.");
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('globalSendPort');
    super.dispose();
  }

  /// Callback function to handle alarm events
  static void printAlarmDetails(int id, Map<String, dynamic> params) async {
    print('Alarm triggered (ID: $id). Params: $params');
  }

  static void sendPort(Map<String, dynamic> message) {
     final sendPort = IsolateNameServer.lookupPortByName('globalSendPort');
    if (sendPort != null) {
      sendPort.send(message);
      print("Message sent to main isolate.");
    } else {
      print("SendPort not found in IsolateNameServer.");
    }
  }

  /// Single function to initialize and schedule an alarm
  Future<void> _initializeAndScheduleAlarm() async {
    print("Alarm scheduled 0 seconds from now.");

    List<AlarmItem> alarms = ref.watch(AlarmStates.alarmsProvider);
    AlarmItem alarm = alarms[0];

    await AndroidAlarmManager.oneShotAt(
      DateTime.now().add(const Duration(seconds: 0)), // Trigger immediately
      alarm.id, // Unique alarm ID
      printAlarmDetails,
      params: {'id': 1}, // Pass serializable data
      exact: true,
      alarmClock: true,
      wakeup: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ThemeConstants.pageTitle(context, "Port test")),
      body: Center(
        child: ElevatedButton(
          onPressed: _initializeAndScheduleAlarm,
          child: const Text("Initialize & Schedule Alarm"),
        ),
      ),
    );
  }
}
