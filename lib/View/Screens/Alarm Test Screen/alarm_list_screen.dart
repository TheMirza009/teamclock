import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/Model/alarm_states.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/View/Drawer/drawer_content.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_card.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Dialogues/themeselection_dialog_ios.dart';
import 'package:time_slider/View/Utils/drawerIcon.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
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

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    HiveFunctions.loadAlarms(ref);

    _timer = Timer.periodic(
      const Duration(seconds: 1), // Checked every second
      (timer) => AlarmFunctions.triggerAlarms(timer, ref),   // Main Alarm Function Call
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  fadeAndRemove(alarms, index, _controller) async {
    print(alarms[index].title);
    await _controller.forward(); // Trigger fade-out animation
    await Future.delayed(
      const Duration(milliseconds: 10),
      () => AlarmFunctions.removeAlarm(ref, index),
    ); // Wait for animation
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(AlarmStates.alarmsProvider);
    ref.listen<List<AlarmItem>>(AlarmStates.alarmsProvider, (previous, next) {
    });

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
      body: alarms.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Transform.translate(
                  offset: Offset(0, -20),
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
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                final fadeController = AnimationController(
                  duration: const Duration(milliseconds: 300), // Fade duration
                  vsync: this,
                );

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
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                      CurvedAnimation(
                        parent: fadeController,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: GestureDetector(
                      onLongPress: () {
                        
                        Vibration.vibrate(pattern: [500, 300, 500], intensities: [128, 255, 128]);
                        print("VIBRATE");
                        },
                      onTap: () async {
                        AlarmFunctions.fireAlarm(ref, alarm);
                      }, 
                      child: AlarmCard(
                        ref: ref,
                        alarm: alarm,
                        index: index,
                        showsubtimes: false,
                        stopAlarmFunction: () async {
                          alarm.isRinging = false;
                          if (alarm.deleteAfterRing) await fadeController.forward();
                          AlarmFunctions.stopAlarm(ref, alarm);
                          }
                      ),
                    ),
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
              offset: const Offset(-2, 4), // The offset of the shadow
              blurRadius: 6, // The blur effect of the shadow
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => AlarmFunctions.addAlarm(context, ref),
          icon: const Icon(Icons.add, size:35),
          // color: const Color.fromARGB(255, 55, 101, 187), // Icon color
          color: ThemeConstants.neutralblue,
        ),
      ),
    );
  }
}