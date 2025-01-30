import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/core/theme/theme_provider_class.dart';
import 'package:teamclock/core/base/controllers/hive_class.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:teamclock/root/Presentation/Modules/Screens/Settings/settings_states.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/Pomodoro%20Dialogues/tuning_dialogue_ios.dart';
import 'package:teamclock/root/Presentation/Widgets/Dialogues/themeselection_dialog_ios.dart';
import 'package:teamclock/core/base/controllers/general_functions.dart';

final GlobalKey fadingWidgetKey = GlobalKey();

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Declarations
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    final themeValue = ref.watch(themeProvider);
    final montserratBold = GoogleFonts.montserrat( color: primaryColor, fontWeight: FontWeight.bold);
    const greyDivider = Divider(color: ThemeConstants.dividerGrey);

    void clearAllDataDialogue(BuildContext context) => showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Clear Tasks"),
            content: const Text("Are you sure you want to clear all data?"),
            actions: [
              // Close the dialogue
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              ),

              // GREAT RESET
              CupertinoDialogAction(
                child: const Text('Yes'),
                onPressed: () =>
                    Functions.grandReset(context: context, ref: ref),
              ),
            ],
          ),
        );

    // Theme Change dialogue
    void showThemeSelectionDialog(BuildContext context) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => const ThemeSelectionDialogIOS(),
      );
    }

    // Helper method to create rows for themes
    Widget buildThemeRow(String text, IconData icon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between text and icon
          Icon(icon, color: primaryColor),
        ],
      );
    }

// Generate the correct theme text widget
    Widget getThemeText(ThemeMode themeValue) {
      if (themeValue == ThemeMode.system) {
        return buildThemeRow(
            "System Default", CupertinoIcons.device_phone_portrait);
      } else if (themeValue == ThemeMode.light) {
        return buildThemeRow("Light Mode", CupertinoIcons.sun_max);
      } else {
        return buildThemeRow("Dark Mode", CupertinoIcons.moon_stars);
      }
    }

    return Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: ThemeConstants.pageTitle(context, "Settings"),
          // Text(
          //   "Settings",
          //   style: GoogleFonts.montserrat(
          //     color: primaryColor,
          //     fontWeight: FontWeight.w600,
          //     fontSize: ThemeConstants.getDynamicFontSize(20),
          //   ),
          // ),
        ),
        body: Column(
          children: [

            // PREMIUM HEADER
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 20),
              child: GestureDetector(
                onTap: () => print(ref.watch(PomodoroStates.timerDurationsNotifierProvider)),
                child: Image.asset("Assets/icons/getPremium.png",
                height: ThemeConstants.screenHeight * 0.18),
              ),
            ),

            // Theme MODE
            ListTile(
              title: Text("Theme Mode", style: montserratBold),
              trailing: getThemeText(themeValue),
              onTap: () => showThemeSelectionDialog(context)),
            greyDivider,

            // SHOW SECONDS
            ListTile(
              title: Text("Show Seconds", style: montserratBold),
              trailing: Switch(
              value: ref.watch(SettingsStates.showSeconds),
              onChanged: (value) {
                ref.read(SettingsStates.showSeconds.notifier).state = value;
                HiveFunctions.saveSettings(ref);
              }),
              onTap: (){}),
            greyDivider,

            // Show 12-Hour format
            ListTile(
              title: Text("Show 12-Hour format", style: montserratBold),
              trailing: Switch(
              value: ref.watch(SettingsStates.show12HourFormat),
              onChanged: (value) {
                ref.read(SettingsStates.show12HourFormat.notifier).state = value;
                HiveFunctions.saveSettings(ref);
              }),
              onTap: () {}),
            greyDivider,

            // POMODORO SECONDS
            ListTile(
              title: Text("Pomodoro Settings", style: montserratBold),
              onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => const TuningDialogueIOS())),
            greyDivider,

            // GRAND RESET
            ListTile(
              title: Text("Clear all data", style: montserratBold),
              onTap: () => clearAllDataDialogue(context)),
            greyDivider,
          ],
        ));
  }
}
