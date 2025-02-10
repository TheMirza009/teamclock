import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teamclock/core/base/controllers/hive_class.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_states.dart';
import 'package:teamclock/root/Presentation/Modules/Drawer/drawer_content.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/Timezone%20Dialogues/addtimezone_dialog.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/simple_cupertino_dialogue.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/themeselection_dialog_ios.dart';
import 'package:teamclock/root/Presentation/Widgets/TimeZone%20components/timezone_ui.dart';
import 'package:teamclock/root/Presentation/Widgets/TimeZone%20components/timezoneminiwidget.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Widgets/svgIcon.dart';

final GlobalKey<_TimezonesScreenState> timezoneScreenKey = GlobalKey();


class TimezonesScreen extends StatefulWidget {
  const TimezonesScreen({
    super.key,
  });

   static void clearAllTimezones() async {
    if (TimezoneStates.timezoneselections.isNotEmpty) {

      // Save the updated time zones list
      await HiveFunctions.saveTimeZones(
        selectedTimeZone: TimezoneStates.selectedTimeZone,
        timezoneList: TimezoneStates.timezoneselections,
      );
    } else {
      debugPrint("No timezones to clear.");
    }
  }

  @override
  State<TimezonesScreen> createState() => _TimezonesScreenState();
}

class _TimezonesScreenState extends State<TimezonesScreen>  with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int counter = 0;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _initializeTimezone();
    _initializeHive();

    // Animation initialization
    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Define the slide animation (swipe to the left)
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0), // Slide to the left
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

    @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  void clearAllTimezones() async {
    await _animationController.forward();
    if (TimezoneStates.timezoneselections.isNotEmpty) {
      final String firstElement = TimezoneStates.timezoneselections.first;

      setState(() {
        // Retain only the first element
        TimezoneStates.timezoneselections
          ..clear()
          ..add(firstElement);
      });

      // Save the updated time zones list
      await HiveFunctions.saveTimeZones(
        selectedTimeZone: TimezoneStates.selectedTimeZone,
        timezoneList: TimezoneStates.timezoneselections,
      );
    } else {
      debugPrint("No timezones to clear.");
    }

    // Reset the animation after it completes
      _animationController.reset();
  }


  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final primaryColor = themeContext.colorScheme.primary;
    final isDark = themeContext.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title:ThemeConstants.pageTitle(context, "Timezones"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => cupertinoSimpleDialogue(
            context: context,
            title: "Clear Timezones",
            content: "Are you sure you want to clear all timezones?",
            onYesPressed: () async {
              clearAllTimezones();
              },
          ),
          icon: svgIcon(color: primaryColor),
        ),

        actions: [
          IconButton(
            onPressed: _addTimeZone,
            icon: Icon(CupertinoIcons.add, color: primaryColor),
          ),
        ],
      ),
      // drawer: const DrawerContent(),
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
              
              // This Column is dependent on States.isLoading
              isLoading
              ? _buildLoadingIndicator()
              : _buildTimeZoneMiniWidgets(),
              
              // addTimezoneButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Add timezone textbutton
  addTimezoneButton() {
    return TextButton(
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
                child: Column(
                  children: [
                    TimeZoneMiniWidget(
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
                    TimezoneStates.timezoneselections.length == 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                            child: Text("Tap the + icon on top to \nadd a timezone.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  fontSize: ThemeConstants.getDynamicFontSize(18),
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
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
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _slideAnimation,
                        child: child,
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
                ),
              );
      }).toList(),
    );
  }
}
