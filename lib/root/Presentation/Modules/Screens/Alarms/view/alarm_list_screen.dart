import 'dart:async';
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/core/base/controllers/notification_controller.dart';
import 'package:time_slider/root/Data/models/alarm_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_ring.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawer_content.dart';
import 'package:time_slider/core/base/controllers/port_controller.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/testscreen.dart';
import 'package:time_slider/root/Presentation/Widgets/Alarm%20Components/alarm_card.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/simple_cupertino_dialogue.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/themeselection_dialog_ios.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawerIcon.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_functions.dart';
import 'package:time_slider/root/Presentation/Widgets/svgIcon.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vibration/vibration.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> with TickerProviderStateMixin  {
  Timer? _timer;
  late AnimationController fadeController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeAlarms();
    PortMessageController.initialize();
    PortMessageController.handleReceived(onReceived: (message) {
      print("MESSAGE RECEIVED: $message");
      ringAlarmFromIsolate(message);
      });

    // Fade Controller for total dismissal
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
      vsync: this,
    );

    // Timer checks every second for alarm condition
    _timer = Timer.periodic(
      const Duration(seconds: 1), // Checked every second
      (timer) {
        setState(() {
          
        });
        // AlarmFunctions.triggerAlarms(ref);
        },  // Main Alarm Function Call
    );
  }

  void ringAlarmFromIsolate(Map<String, dynamic> message) {
    if (message['id'] != null) {
      List<AlarmItem> alarmlist = ref.watch(AlarmStates.alarmsProvider);
      AlarmItem alarm = alarmlist.firstWhere((alarm) => alarm.id == message['id']);
      alarm.isRinging = true;
      // AlarmFunctions.fireAlarm(ref, alarm);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    fadeController.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  Future<void> _initializeAlarms() async {
    setState(() {
      isLoading = true;
    });

    await HiveFunctions.loadAlarms(ref);

    setState(() {
      isLoading = false;
    });
  }

  fadeAndRemove(alarms, index, controller) async {
    print(alarms[index].title);
    await controller.forward(); // Trigger fade-out animation
    await Future.delayed(
      const Duration(milliseconds: 10),
      () => AlarmFunctions.removeAlarm(ref, index),
    ); // Wait for animation
  }

  @override
  Widget build(BuildContext context) {
    final List<AlarmItem> alarms = ref.watch(AlarmStates.alarmsProvider);
    ref.listen<List<AlarmItem>>(AlarmStates.alarmsProvider, (previous, next) {
      if (previous != next) {
        final alarms = ref.watch(AlarmStates.alarmsProvider);
        AlarmStates.alarmList = alarms;
      }
    });

    // Call onReceived
    // PortMessageController.handleReceived(onReceived: (message) {
    //   print("MESSAGE RECEIVED: $message");
    //   ringAlarmFromIsolate(message);
    //   });

    // Color declarations
    final themeContext = Theme.of(context);
    final primaryColor = themeContext.colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      centerTitle: true,
      title: ThemeConstants.pageTitle(context, "Alarms"), 
      leading: IconButton(
        onPressed: () => cupertinoSimpleDialogue(
          context: context,
          title: "Clear Alarms",
          content: "Are you sure you want to clear all alarms?",
          onYesPressed: () async {
            await fadeController.forward();
            await AlarmFunctions.clearAlarms(ref);
            fadeController.reset();
            },
          ),
          icon: svgIcon(color: primaryColor),
        ),
        actions: [
          IconButton(
            onPressed: () => AlarmFunctions.addAlarm(context, ref),
            icon: Icon(CupertinoIcons.add, color: primaryColor),
          ),
        ],
      ),
      // title: Text('Alarm List', style: ThemeConstants.notBoldText(context))),
      drawer: const DrawerContent(),
      body: 
      isLoading
          ? const Center(
              child: CircularProgressIndicator(
                // color: themeContext.colorScheme.onSecondary,
                color: ThemeConstants.neutralblue,
              ),
            )
          : alarms.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Text(
                    "Click on the + icon to add an alarm.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      fontSize: ThemeConstants.getDynamicFontSize(26),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: alarms.length + 1, // + 1 for handling last item
              itemBuilder: (context, index) {

                // Scrollable space at the end
                if (index == alarms.length) return const SizedBox(height: 200); 

                // Animation controller for auto-dismissal
                final singleFadeController = AnimationController(
                  duration: const Duration(milliseconds: 300), // Adjust duration as needed
                  vsync: this,
                );

                // Current Alarm item
                final alarm = alarms[index];

                // Main Alarm Tile
                return Dismissible(
                  key: Key(alarm.id.toString()), // Use a unique key for each alarm
                  onDismissed: (direction) => AlarmFunctions.removeAlarm(ref, alarm),
                  background: Container(
                    color: const Color.fromARGB(15, 172, 47, 38),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Color.fromARGB(255, 172, 47, 38),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Fade setting
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                      CurvedAnimation(
                        parent: alarm.deleteAfterRing ? singleFadeController : fadeController,
                        curve: Curves.easeOut,
                      ),
                    ),

                    // Test Section
                    child: GestureDetector(
                      onLongPress: () {
                        AlarmFunctions.editAlarm(context, ref, alarm);
                        Vibration.vibrate(pattern: [100], intensities: [128]);
                        print("VIBRATE");
                      },
                      onTap: () async {
                        print("TAPPED: ID ${alarm.id}");
                        // AlarmFunctions.fireAlarm(ref, alarm);
                        await AndroidAlarmManager.oneShotAt(
                          alarm.selectedTime,
                          alarm.id,
                          AlarmRing.alarmCallback,
                          // AlarmRing.sendTestPortMessage,
                          params: alarm.toJson(),
                          exact: true,
                          alarmClock: true,
                          wakeup: true,
                          allowWhileIdle: true,
                        );
                      },

                      // Main ALARM CARD UI
                      child: AlarmCard(
                              ref: ref,
                              alarm: alarm,
                              index: index,
                              showsubtimes: false,
                              stopAlarmFunction: () async {
                                alarm.isRinging = false;
                                  await singleFadeController.forward();
                                  AlarmRing.stopAlarm(alarm.id);
                                  AlarmFunctions.finishAlarm(ref, alarm.id);
                                  // await AlarmFunctions.stopAlarm(ref, alarm);
                                  await Future.delayed(const Duration(milliseconds: 400));
                                  singleFadeController.reset();
                              }),
                    ),
                  ),
                );
              },
            ),
    );
  }
}