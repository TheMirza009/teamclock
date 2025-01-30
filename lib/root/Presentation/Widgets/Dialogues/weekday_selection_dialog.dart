import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:teamclock/core/utilities/ringtones_class.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Data/models/weekdays_model.dart';

class WeekdaySelectionDialog extends StatefulWidget {
  final Weekday existingWeekdays;
  final ValueChanged<Weekday> onWeekdaysSelected; // Callback to notify parent screen

  const WeekdaySelectionDialog({super.key, required this.onWeekdaysSelected, required this.existingWeekdays});

  @override
  State<WeekdaySelectionDialog> createState() => _WeekdaySelectionDialogState();
}

class _WeekdaySelectionDialogState extends State<WeekdaySelectionDialog> {
  Weekday weekdays = Weekday.none();

  @override
  void initState() {
    super.initState();
    weekdays = widget.existingWeekdays;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void printWeekdays() {
    print("Monday: ${weekdays.monday}");
    print("Tuesday: ${weekdays.tuesday}");
    print("Wednesday: ${weekdays.wednesday}");
    print("Thursday: ${weekdays.thursday}");
    print("Friday: ${weekdays.friday}");
    print("Saturday: ${weekdays.saturday}");
    print("Sunday: ${weekdays.sunday}");
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weekdayNames = Weekday.names;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "Select Weekdays",
                            style: GoogleFonts.montserrat(
                              fontSize: ThemeConstants.getDynamicFontSize(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 370, // Adjust height as needed
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: const Radius.circular(15),
                        child: ListView.builder(
                          
                          itemCount: weekdayNames.length , // Add one more item for the extra space
                          itemBuilder: (context, index) {
                        
                            // Space at the end of the list
                            // if (index == weekdayNames.length) return const SizedBox(height: 10); 
                        
                            final weekday = weekdayNames[index];

                            // Get the corresponding day boolean value from the _weekday instance
                            bool currentDayState;
                            switch (index) {
                              case 0: currentDayState = weekdays.monday; break;
                              case 1: currentDayState = weekdays.tuesday; break;
                              case 2: currentDayState = weekdays.wednesday; break;
                              case 3: currentDayState = weekdays.thursday; break;
                              case 4: currentDayState = weekdays.friday; break;
                              case 5: currentDayState = weekdays.saturday; break;
                              case 6: currentDayState = weekdays.sunday; break;
                              default: currentDayState = false; break;
                            }

                            return SizedBox(
                              height: 50,
                              child: ListTile(
                                trailing: Switch(
                                value: currentDayState,
                                onChanged: (value) {
                                  setState(() {
                                    // Recreate the Weekday instance with the updated state
                                    weekdays = Weekday(
                                      monday: index == 0 ? value : weekdays.monday,
                                      tuesday: index == 1 ? value : weekdays.tuesday,
                                      wednesday: index == 2 ? value : weekdays.wednesday,
                                      thursday: index == 3 ? value : weekdays.thursday,
                                      friday: index == 4 ? value : weekdays.friday,
                                      saturday: index == 5 ? value : weekdays.saturday,
                                      sunday: index == 6 ? value : weekdays.sunday,
                                    );
                                  });
                                },
                              ),
                                title: Text(
                                  "  $weekday",
                                  style: GoogleFonts.montserrat(fontSize: 18, color: Theme.of(context).colorScheme.primary),
                                ),
                                onTap: () async {
                                  
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                      
                          // ALL DAYS TRUE
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceBright),
                              onPressed: () => setState(() {
                                weekdays = Weekday.none();
                              }),
                              child: const Text("Once"),
                            ),
                          ),

                          const SizedBox(width: 10),
                      
                          // ALL DAYS FALSE
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceBright),
                              onPressed: () => setState(() {
                                weekdays = Weekday.everyday();
                              }),
                              child: const Text("Everyday"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 50),
                  ],
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.onWeekdaysSelected(weekdays);
                      printWeekdays();
                      //? CONFIRAMTION FUNCTION HERE
                    },
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
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
