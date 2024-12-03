import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/Provider%20Classes/theme_class.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_alarm_screen_add_alarm.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Alarm%20Components/alarm_tile.dart';

class AlarmScreen extends ConsumerWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DECLARATIONS
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    final themeValue = ref.watch(themeProvider);
    final montserratBold = GoogleFonts.montserrat(
        color: primaryColor, fontWeight: FontWeight.bold);
    const greyDivider = Divider(color: ThemeConstants.dividerGrey);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alarms",
          style: GoogleFonts.montserrat(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: ThemeConstants.getDynamicFontSize(20),
          ),
        ),
        backgroundColor: Colors.transparent,
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
          onPressed: () => Navigator.push(
            context, 
            CupertinoPageRoute(builder: (_) => const AddAlarmScreen())),
          icon: const Icon(Icons.add, size:35),
          // color: const Color.fromARGB(255, 55, 101, 187), // Icon color
          color: ThemeConstants.neutralblue,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: List.generate(8, (index) {
                  final alarmProvider = StateProvider<bool>((ref) => false);
                  final locations = [
                    "Cairo, Egypt",
                    "New York, USA",
                    "Argentina",
                    "Kabul, Afghanistan",
                    "Kabul, Afghanistan",
                    "Kabul, Afghanistan",
                    "Kabul, Afghanistan",
                    "Kabul, Afghanistan",
                  ];
                  final titles = [
                    "Meeting with Clients",
                    "Visit the new dealership dealership dealership dealership",
                    "Skype meeting",
                    "Frontend review",
                    "Frontend review",
                    "Frontend review",
                    "Frontend review",
                    "Frontend review",
                  ];
                  return Column(
                    children: [
                      AlarmTile(
                        provider: alarmProvider,
                        location: locations[index],
                        title: titles[index],
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: ThemeConstants.screenHeight*0.2),
            ],
          ),
        ),
      ),
    );
  }
}
