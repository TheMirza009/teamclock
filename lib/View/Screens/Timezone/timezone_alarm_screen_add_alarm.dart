import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/custom_list_tile.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  // Initial values for the pickers
  int selectedAmPmIndex = 0; // 0 for AM, 1 for PM
  int selectedHourIndex = 0; // Index for hours (0 corresponds to 1)
  int selectedMinuteIndex = 0; // Index for minutes (0 corresponds to 00)
  bool vibratebool = false;
  bool deletebool = false;

  @override
  Widget build(BuildContext context) {
    // final themeValue = ref.watch(themeProvider);
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    final montserratBold = GoogleFonts.montserrat(
        color: primaryColor, fontWeight: FontWeight.bold);
    const greyDivider = Divider(color: ThemeConstants.dividerGrey);

    const double itemExtentAll = 60;
    final displayMedium = GoogleFonts.robotoMono(fontWeight: FontWeight.w300, fontSize: 22);
    // final displayMedium = Theme.of(context).textTheme.displayMedium;

    return Scaffold(
      // appBar: AppBar(
      //   title:
      //   Text("Cupertino Time Picker", style: GoogleFonts.montserrat(
      //       color: primaryColor,
      //       fontWeight: FontWeight.w600,
      //       fontSize: ThemeConstants.getDynamicFontSize(20),),),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisSize: MainAxisSize.min,
          children: [
            // TOP SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                const Column(
                  children: [
                    Text(
                      "Add Alarm",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    Text(
                      "Alarm sets off in 2 hours, 53 minutes",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check, size: 30),
                ),
              ],
            ),

            // Display selected time
            // Text(
            //   "Selected Time: ${selectedHourIndex + 1}:${selectedMinuteIndex.toString().padLeft(2, '0')} ${selectedAmPmIndex == 0 ? "AM" : "PM"}",
            //   style: const TextStyle(fontSize: 20),
            // ),

            // Cupertino picker
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
                height: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // AM/PM Picker
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: itemExtentAll,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedAmPmIndex = index;
                          });
                        },
                        children: [
                          Center(child: Text("AM", style: displayMedium)),
                          Center(child: Text("PM", style: displayMedium)),
                        ],
                      ),
                    ),

                    // Hours Picker
                    Expanded(
                      child: CupertinoPicker(
                        looping: true,
                        itemExtent: itemExtentAll,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHourIndex = index;
                          });
                        },
                        children: List.generate(
                          12,
                          (index) => Center(
                            child: Text(
                              (index + 1).toString().padLeft(2, '0'),
                              style: displayMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Minutes Picker
                    Expanded(
                      child: CupertinoPicker(
                        looping: true,
                        itemExtent: itemExtentAll,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinuteIndex = index;
                          });
                        },
                        children: List.generate(
                          60,
                          (index) => Center(
                              child: Text(index.toString().padLeft(2, '0'), style: displayMedium)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // OPTIONS COLUMN
            Column(
              children: [
                CustomListTile(
                  title: "Title",
                  subtitle: "Meeting with the clients and automatic vision.",
                  onTap: () => print("Low interest"),
                ),
                const CustomListTile(
                  title: "Timezones",
                  subtitle: "Cairo, Egypt\nKarachi Pakistan",
                ),
                // const CustomListTile(
                //   title: "Alarm Settings",
                //   subtitle: "",
                //   ),
                const CustomListTile(
                  title: "Ringtone",
                  subtitle: "default ringtone",
                ),
                const CustomListTile(
                  title: "Repeat",
                  subtitle: "Once",
                ),
                CustomListTile(
                  title: "Vibrate on ring",
                  subtitle: "",
                  showChevron: false,
                  trailingWidget: Switch(
                    value: vibratebool,
                    onChanged: (value) {
                      setState(() {
                        vibratebool = value;
                      });
                    }),
                ),
                CustomListTile(
                  title: "Delete after ring",
                  subtitle: "",
                  showDivider: false,
                  showChevron: false,
                  trailingWidget: Switch(
                      value: deletebool,
                      onChanged: (value) => setState(() {
                            deletebool = value;
                          })),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
