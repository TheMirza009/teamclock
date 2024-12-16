import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/Models/alarm_item.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_test_screen.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/ViewModel/alarm_functions.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final alarmSwitch = StateProvider<bool>((ref) => false);

class AlarmCard extends StatelessWidget {
  // Temporarily made into stateful
  final AlarmItem alarm;
  final WidgetRef ref;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final now = tz.TZDateTime.now(tz.getLocation(alarm.timezone));
    final timeLeft = alarm.timeLeft(now);
    final hour = TimeFunctions.formatHourOnly(alarm.selectedTime, true);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Interview with Client",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("$hour:${alarm.selectedTime.minute.toString().padLeft(2, '0')}",
                        style: GoogleFonts.montserrat(
                            fontSize: 28, fontWeight: FontWeight.w600)),
                    Column(
                      children: [
                        const Icon(CupertinoIcons.sun_haze, size: 15,),
                        Text("AM",
                            style: GoogleFonts.montserrat(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: ThemeConstants.screenWidth * 0.51,
              child: Transform.translate(
                offset: const Offset(0, -9),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Text("New York, USA",
                            style: GoogleFonts.montserrat(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    SizedBox(height: ThemeConstants.screenHeight * 0.001),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Current time",
                            style: GoogleFonts.montserrat(
                                fontSize: 10, fontWeight: FontWeight.w500)),
                        Text("12 : 53 AM",
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
                          style: GoogleFonts.montserrat( fontSize: 10, fontWeight: FontWeight.w500 ),
                        ),
                        Text(
                          "11 : 53 PM",
                          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w500 ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: ThemeConstants.screenHeight * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.alarm, size: 10),
                    SizedBox(width: ThemeConstants.screenWidth * 0.01),
                    Row(
                      children: [
                        Text("Today - ",
                            style: GoogleFonts.montserrat(
                                fontSize: 8, fontWeight: FontWeight.w500)),
                        Text("4 hours and 53 minutes remain",
                            style: GoogleFonts.montserrat(
                                fontSize: 8, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 80, 214, 203))),
                      ],
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Switch(
                          value: ref.watch(alarmSwitch),
                          onChanged: (value) => ref.read(alarmSwitch.notifier).state = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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