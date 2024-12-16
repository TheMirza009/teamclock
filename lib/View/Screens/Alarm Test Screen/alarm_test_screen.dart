import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_card.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_alarm_screen_add_alarm.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Alarm%20Dialogues/add_alarm_dialogue.dart';
import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final alarmsProvider = StateProvider<List<AlarmItem>>((ref) => []);

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _timer = Timer.periodic(const Duration(seconds: 1), _checkAlarms);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAlarms(Timer timer) {
    final alarms = ref.read(alarmsProvider); // Read alarms

    for (final alarm in alarms) {
      final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));
      if 
      (!alarm.isRinging 
      && alarm.selectedTime.hour == now.hour 
      && alarm.selectedTime.minute == now.minute 
      && alarm.selectedTime.second == now.second) {
        alarm.isRinging = true;
        AlarmFunctions.playAlarmSound();
        NotificationController.showAlarmNotification();
      }
    }
    ref.read(alarmsProvider.notifier).state = List.from(alarms); // Trigger UI update
  }

  Future<void> _addAlarm() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddTimezoneDialogTest(
          onTimezoneAdded: (String timezone, tz.TZDateTime selectedTime) {
            ref.read(alarmsProvider.notifier).state = [
              ...ref.read(alarmsProvider),
              AlarmItem(timezone: timezone, selectedTime: selectedTime),
            ];
          },
        );
      },
    );
  }

  Future<void> _newAlarm() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddAlarmScreen(
          onTimezoneAdded: (String timezone, tz.TZDateTime selectedTime) {
            ref.read(alarmsProvider.notifier).state = [
              ...ref.read(alarmsProvider),
              AlarmItem(timezone: timezone, selectedTime: selectedTime),
            ];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Alarm List', style: ThemeConstants.notBoldText(context))),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return AlarmCard(alarm: alarm, ref: ref);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newAlarm,
        // onPressed: _addAlarm,
        child: const Icon(Icons.add),
      ),
    );
  }
}