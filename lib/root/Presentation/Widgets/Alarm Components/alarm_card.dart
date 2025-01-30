import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/root/Data/models/alarm_item.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_states.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Settings/settings_states.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/view/alarm_list_screen.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Alarms/viewmodel/alarm_functions.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmCard extends StatefulWidget {

  // Temporarily made into stateful
  final WidgetRef ref;
  final AlarmItem alarm;
  final int index;
  final bool showsubtimes;
  final VoidCallback  stopAlarmFunction;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.ref,
    required this.index,
    required this.showsubtimes,
    required this.stopAlarmFunction,
  });

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {

    bool showing12HourFormat = widget.ref.watch(SettingsStates.show12HourFormat);
    int selectedhour = widget.alarm.selectedTime.hour;
    final now = tz.TZDateTime.now(tz.getLocation(widget.alarm.timezone));
    final timeLeft = widget.alarm.timeLeft(now);
    final hour = TimezoneFunctions.formatHourOnly(widget.alarm.selectedTime, showing12HourFormat);
    bool past12 = selectedhour >= 12;
    String ampm = past12 ? "PM" : "AM";
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    Color neutralGreenLight = const Color.fromARGB(255, 80, 214, 203);

    // Time Strings
    String currentTime = "${(now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(2, '0')} : ${now.minute.toString().padLeft(2, '0')} : ${now.second.toString().padLeft(2, '0')} ${now.hour >= 12 ? "PM" : "AM"}";
    String localTime = "${(DateTime.now().hour % 12 == 0 ? 12 : DateTime.now().hour % 12).toString().padLeft(2, '0')} : ${DateTime.now().minute.toString().padLeft(2, '0')} : ${DateTime.now().second.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? "PM" : "AM"}";
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color disabledPrimaryColor = primaryColor.withAlpha(80);

    // MAIN UI
    // return Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15),
    //     side: BorderSide(color: Colors.grey.shade300, width: 2),
    //   ),

    // MAIN UI
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: ThemeConstants.timeContainerDecor(
          context: context,
          isSelected: false,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: ThemeConstants.screenWidth * 0.5,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Check if the available width is enough to show the title on one line
                        bool isMultiline = (widget.alarm.title.length * 18.0) > constraints.maxWidth;

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: isMultiline
                                  ? 10.0
                                  : 0.0), // Only add space if title spans 2 lines
                          child: Text(
                            widget.alarm.title,
                            maxLines: 2,
                            textHeightBehavior: const TextHeightBehavior(
                                leadingDistribution:
                                    TextLeadingDistribution.even),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: widget.alarm.isActive
                                  ? primaryColor
                                  : disabledPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              height: 1.2, // Reduces space between lines
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.alarm.isRinging = !widget.alarm.isRinging,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$hour:${widget.alarm.selectedTime.minute.toString().padLeft(2, '0')}",
                            style: GoogleFonts.montserrat(
                              color: widget.alarm.isActive ? primaryColor : disabledPrimaryColor,
                              fontSize: 28, fontWeight: FontWeight.w600)),
                        Column(
                          children: [
                            Icon(past12 ? CupertinoIcons.moon_stars : CupertinoIcons.sun_haze, size: showing12HourFormat ? 15 : 18, color: widget.alarm.isActive ? primaryColor : disabledPrimaryColor),
                            showing12HourFormat ? Text(ampm, style: GoogleFonts.montserrat(
                              color: widget.alarm.isActive 
                              ? primaryColor 
                              : disabledPrimaryColor, 
                              fontSize: 12, 
                              fontWeight: FontWeight.w600,
                              ),
                            ) : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: ThemeConstants.screenWidth * 0.51,
                child: Transform.translate(
                  offset: const Offset(0, -9),
                  child: Column(
                    children: [
                      // SizedBox(height: ThemeConstants.screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(TimezoneFunctions.getCityAndCountryFromTimezone(widget.alarm.timezone),
                              style: GoogleFonts.montserrat(
                                color: widget.alarm.isActive ? primaryColor : disabledPrimaryColor,
                                  fontSize: 12, fontWeight: widget.showsubtimes ? FontWeight.w700 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      widget.showsubtimes ? _subtimes(currentTime, localTime) : const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: ThemeConstants.screenHeight * 0.01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.alarm, 
                      size: 10, 
                      color: widget.alarm.isActive 
                        ? primaryColor 
                        : disabledPrimaryColor,
                      ),
                      SizedBox(width: ThemeConstants.screenWidth * 0.001),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Today - ",
                                style: GoogleFonts.montserrat(
                                  color: widget.alarm.isActive 
                                  ? primaryColor 
                                  : disabledPrimaryColor, 
                                  fontSize: 8, 
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.alarm.isRinging ? "Alarm Ringing!" :
                              AlarmFunctions.calculateTimeDifference(widget.alarm.timezone, widget.alarm.selectedTime, showing12HourFormat),
                                style: GoogleFonts.montserrat(
                                    fontSize: 8, 
                                    fontWeight: FontWeight.w500, 
                                    color: isLightMode 
                                    ? ThemeConstants.neutralgreen 
                                    : neutralGreenLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(-0.5, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
      
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: widget.alarm.isRinging
                    ? Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          key: ValueKey(widget.alarm.isRinging), // Unique key for switching
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                          ),
                          onPressed: widget.stopAlarmFunction,
                          // () {
                          //   widget.alarm.isRinging = false; // Stop the ringing state
                          //   AlarmFunctions.stopAlarm(ref, widget.alarm); // Stop the sound
                          // },
                          child: Text(
                            "Stop Alarm",
                            style: GoogleFonts.montserrat(),
                          ),
                        );
                      },
                      
                    )
                    : Consumer(
                        key: ValueKey(widget.alarm.isRinging), // Unique key for switching
                        builder: (context, ref, child) {
                          final isSwitchOn = ref.watch(AlarmStates.alarmSwitchProvider(widget.index));
                          return Switch(
                            value: isSwitchOn,
                            onChanged: (value) {
                                  ref.read(AlarmStates.alarmSwitchProvider(widget.index).notifier).state = value;
                                  setState(() {
                                    widget.alarm.isActive =  value; // Update active state
                                  });
                                },
                          );
                        },
                      ),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _subtimes(currentTime, localTime) {
    return Column(
      children: [
        SizedBox(height: ThemeConstants.screenHeight * 0.001),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Selected time",
                style: GoogleFonts.montserrat(
                    fontSize: 10, fontWeight: FontWeight.w500)),
            Text(
                // "12 : 53 AM",
                currentTime,
                style: GoogleFonts.montserrat(
                    fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: ThemeConstants.screenHeight * 0.001),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Local time",
              style: GoogleFonts.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w500),
            ),
            Text(
              localTime,
              style: GoogleFonts.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }



// Widget alarmTile() {
//   return 
// }

// Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15),
    //     side: BorderSide(color: Colors.grey.shade300, width: 2),
    //   ),
    //   margin: const EdgeInsets.all(8),
    //   child: Padding(
    //     padding: const EdgeInsets.all(12.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text('Timezone: ${alarm.timezone}',
    //             style: Theme.of(context).textTheme.labelSmall),
    //         Text(
    //           'Current Time: ${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
    //           style: Theme.of(context).textTheme.bodyMedium,
    //         ),
    //         Text(
    //           'Alarm Time: ${alarm.selectedTime.hour}:${alarm.selectedTime.minute.toString().padLeft(2, '0')}',
    //           style: Theme.of(context).textTheme.bodyMedium,
    //         ),
    //         Text(
    //           'Time Left: ${timeLeft.inHours}h ${timeLeft.inMinutes % 60}m ${timeLeft.inSeconds % 60}s',
    //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
    //         ),
    //         const SizedBox(height: 8),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             IconButton(
    //               icon: const Icon(Icons.stop, color: Colors.red),
    //               onPressed: () => AlarmFunctions.stopAlarm(alarm, ref),
    //               tooltip: 'Stop Alarm',
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.delete, color: Colors.grey),
    //               onPressed: () {
    //                 ref.read(alarmsProvider.notifier).state = ref
    //                     .read(alarmsProvider)
    //                     .where((existingAlarm) => existingAlarm != alarm)
    //                     .toList();
    //               },
    //               tooltip: 'Remove Alarm',
    //             ),
    //           ],
    //         ),

    //       ],
    //     ),
    //   ),
    // );