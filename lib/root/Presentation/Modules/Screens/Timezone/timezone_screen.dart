import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_slider/core/base/controllers/hive_class.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawer_content.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/view/alarm_list_screen.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/themeselection_dialog_ios.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawerIcon.dart';
import 'package:time_slider/root/Presentation/Widgets/TimeZone%20components/timezone_ui.dart';
import 'package:time_slider/root/Presentation/Widgets/TimeZone%20components/timezoneminiwidget.dart';
import 'package:time_slider/core/theme/theme_constants.dart';

class TimezonesScreen extends StatefulWidget {
  const TimezonesScreen({
    super.key,
  });

  @override
  State<TimezonesScreen> createState() => _TimezonesScreenState();
}

class _TimezonesScreenState extends State<TimezonesScreen> {
  int counter = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializeTimezone();
    _initializeHive();
  }

  Future<void> _initializeTimezone() async {
    await TimezoneStates.initializeTimeZone();
    setState(() {
      isLoading = false;  // Data has been loaded, so stop loading
    });
  }

  Future<void> _initializeHive() async {
    try {
      // Open Hive box and load data
      await Hive.openBox('timezones');
      final loadedNumber = await HiveFunctions.readData(key: 2);
      final timeZoneData = await HiveFunctions.readData(key: 1);

      // Update state with the loaded data
      setState(() {
        counter = loadedNumber ?? 0;
        TimezoneStates.selectedTimeZone = timeZoneData['selectedtimezone'] ?? 'Asia/Karachi';
        TimezoneStates.timezoneselections = timeZoneData['timezoneselections'] ?? [];
        isLoading = false;  // Stop loading
      });
    } catch (e) {
      setState(() {
        isLoading = false;  // Stop loading on error
      });
      print('Error loading Hive data: $e');
    }
  }

  void _addTimeZone() async {
    showDialog(
      context: context,
      builder: (context) {
        return AddTimezoneDialog(
          onTimezoneAdded: (timezone) {
            setState(() {
              TimezoneStates.timezoneselections.add(timezone);  // Add the new timezone to the list
            });
            HiveFunctions.saveTimeZones(
              selectedTimeZone: TimezoneStates.selectedTimeZone,
              timezoneList: TimezoneStates.timezoneselections,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final primaryColor = themeContext.colorScheme.primary;
    final isDark = themeContext.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title:ThemeConstants.pageTitle(context, "Timezones"),
        backgroundColor: Colors.transparent,
        leading: buildDrawerIconButton(context),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => const AlarmListScreen(),
            // builder: (_) => const AlarmScreen(),
          ),
        ),
            icon: Icon( CupertinoIcons.alarm, color: primaryColor),
          ),
          // IconButton(
          //   onPressed: () => _showThemeSelectionDialog(context),
          //   icon: Icon( isDark ? Icons.dark_mode : Icons.light_mode, color: primaryColor),
          // ),
        ],
      ),
      drawer: const DrawerContent(),
      body: _buildBody(context),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const ThemeSelectionDialogIOS(),
    );
  }

  // Updated body to conditionally render the TimeZoneMiniWidget only when loading is finished
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              // TimeZoneMainUI remains unchanged regardless of loading state
              TimeZoneMainUI(
                selectedTimeZone: TimezoneStates.selectedTimeZone,
                initialCounter: counter,
                slider: Slider(
                  max: 1440,
                  min: -1440,
                  value: counter.toDouble(),
                  onChanged: (value) async {
                    setState(() {
                      counter = value.toInt();
                    });
                    await HiveFunctions.saveData(key: 2, value: counter);
                  },
                ),
                onResetPressed: () async {
                  setState(() {
                    counter = 0;
                  });
                  HiveFunctions.saveData(key: 2, value: counter);
                },
              ),
              // const FadingWidget(
              //   child: Text("RISE"),
              // ),
              // This Column is dependent on States.isLoading
              isLoading
              ? _buildLoadingIndicator()
              : _buildTimeZoneMiniWidgets(),
              
              TextButton(
                onPressed: _addTimeZone,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "+ Add Timezone",
                      style: GoogleFonts.montserrat(
                        fontSize: ThemeConstants.getDynamicFontSize(17),
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(23.0),
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildTimeZoneMiniWidgets() {
    return Column(
      children: TimezoneStates.timezoneselections.asMap().entries.map((entry) {
        final index = entry.key;
        final timezone = entry.value;

        bool isFirst = index == 0;

        return isFirst
            ? GestureDetector(
                onTap: () async {
                  setState(() {
                    TimezoneStates.selectedTimeZone = timezone;
                  });
                  await HiveFunctions.saveTimeZones(
                    selectedTimeZone: TimezoneStates.selectedTimeZone,
                    timezoneList: TimezoneStates.timezoneselections,
                  );
                },
                child: TimeZoneMiniWidget(
                  isSelected: TimezoneStates.selectedTimeZone == timezone,
                  dynamicMinutes: counter,
                  timezone: timezone,
                  selectedTimeZone: TimezoneStates.selectedTimeZone,
                  isFirst: isFirst,
                  onDeletePressed: () async {
                    setState(() {
                      TimezoneStates.timezoneselections.remove(timezone);
                    });
                    await HiveFunctions.saveTimeZones(
                      selectedTimeZone: TimezoneStates.selectedTimeZone,
                      timezoneList: TimezoneStates.timezoneselections,
                    );
                  },
                ),
              )
            : Dismissible(
                key: Key(timezone),
                direction: DismissDirection.endToStart, // Swipe left to delete
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.transparent,
                  child: const Text("Delete", style: TextStyle(color: Color.fromARGB(255, 185, 42, 42),),),
                  // Icon(
                  //   Icons.delete,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                ),
                onDismissed: (direction) async {
                  setState(() {
                    TimezoneStates.timezoneselections.remove(timezone);
                  });
                  await HiveFunctions.saveTimeZones(
                    selectedTimeZone: TimezoneStates.selectedTimeZone,
                    timezoneList: TimezoneStates.timezoneselections,
                  );
                },
                dismissThresholds: const {
                  DismissDirection.endToStart: 0.3, // 30% swipe to delete
                },
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      TimezoneStates.selectedTimeZone = timezone;
                    });
                    await HiveFunctions.saveTimeZones(
                      selectedTimeZone: TimezoneStates.selectedTimeZone,
                      timezoneList: TimezoneStates.timezoneselections,
                    );
                  },
                  child: TimeZoneMiniWidget(
                    isSelected: TimezoneStates.selectedTimeZone == timezone,
                    dynamicMinutes: counter,
                    timezone: timezone,
                    selectedTimeZone: TimezoneStates.selectedTimeZone,
                    isFirst: isFirst,
                    onDeletePressed: () async {
                      setState(() {
                        TimezoneStates.timezoneselections.remove(timezone);
                      });
                      await HiveFunctions.saveTimeZones(
                        selectedTimeZone: TimezoneStates.selectedTimeZone,
                        timezoneList: TimezoneStates.timezoneselections,
                      );
                    },
                  ),
                ),
              );
      }).toList(),
    );
  }
}
