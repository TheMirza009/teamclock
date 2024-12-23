import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/Model/alarm_states.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/View/Drawer/drawer_content.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_card.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_alarm_screen_add_alarm.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/Alarm%20Dialogues/add_alarm_dialogue.dart';
import 'package:time_slider/View/Utils/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/View/Utils/Dialogues/themeselection_dialog_ios.dart';
import 'package:time_slider/View/Utils/drawerIcon.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    HiveFunctions.loadAlarms(ref);
    _timer = Timer.periodic(const Duration(seconds: 1), _checkAlarms);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAlarms(Timer timer) {
    final alarms = ref.read(AlarmStates.alarmsProvider); // Read alarms

    for (final alarm in alarms) {
      // final isActive = ref.watch(AlarmStates.alarmSwitchProvider(index));
      final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));
      if 
      (!alarm.isRinging 
      && alarm.selectedTime.hour == now.hour && alarm.selectedTime.minute == now.minute
      && alarm.selectedTime.second == now.second && alarm.isActive == true) {
        alarm.isRinging = true;
        AlarmFunctions.playAlarmSound(alarm.ringtone);
        NotificationController.showAlarmNotification();
      }
    }
    ref.read(AlarmStates.alarmsProvider.notifier).state = List.from(alarms); // Trigger UI update
  }

  Future<void> _addAlarm() async {
    print((DateTime.now().hour % 12));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AddAlarmScreen(
          onTimezoneAdded: (String alarmTitle, String timezone, tz.TZDateTime selectedTime, String ringtone) async {
             ref.read(AlarmStates.alarmsProvider.notifier).state = [
              ...ref.read(AlarmStates.alarmsProvider),
              AlarmItem(
                id: DateTime.now().microsecondsSinceEpoch,
                title: alarmTitle,
                timezone: timezone, 
                selectedTime: selectedTime,
                ringtone: ringtone,
                ),
            ];
            final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
            HiveFunctions.saveAlarmList(alarmList);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(AlarmStates.alarmsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      title:ThemeConstants.pageTitle(context, "Alarms"), 
      leading: buildDrawerIconButton(context),
      actions: [
        IconButton(onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => const ThemeSelectionDialogIOS(),
      ), icon: Icon(Icons.sunny_snowing))
      ],
      ),
      drawer: const DrawerContent(),
      // title: Text('Alarm List', style: ThemeConstants.notBoldText(context))),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return Dismissible(
            key: Key(alarm.id.toString()), // Use a unique key for each alarm
            onDismissed: (direction) {

              if (alarms[index].isRinging) {
                alarms[index].isRinging = false; // Stop the ringing state
                AlarmFunctions.stopAlarm(alarms[index], ref); // Add a function to stop the sound
              }

              ref.read(AlarmStates.alarmsProvider.notifier).state = [
                ...alarms..removeAt(index),
              ];

              final List<AlarmItem> alarmList = ref.watch(AlarmStates.alarmsProvider);
              HiveFunctions.saveAlarmList(alarmList);
            },
            background: Container(
              color: const Color.fromARGB(15, 172, 47, 38),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Color.fromARGB(255, 172, 47, 38), fontSize: 15),
                  ),
                ),
              ),
            ),
            child: AlarmCard(
              ref: ref,
              alarm: alarm,
              index: index,
              showsubtimes: false,
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: 70.0, // Diameter of the button
        height: 70.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color with some transparency
              blurRadius: 6, // The blur effect of the shadow
              offset: const Offset(-2, 4), // The offset of the shadow
            ),
          ],
        ),
        child: IconButton(
          onPressed: _addAlarm,
          icon: const Icon(Icons.add, size:35),
          // color: const Color.fromARGB(255, 55, 101, 187), // Icon color
          color: ThemeConstants.neutralblue,
        ),
      ),
    );
  }
}