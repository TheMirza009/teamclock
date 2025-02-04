import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/core/theme/theme_constants.dart';

class AlarmSettingsPage extends StatelessWidget {
static const platform = MethodChannel('com.team.teamclock/alarmsettings');

  const AlarmSettingsPage({super.key});

Future<void> openAlarmSettings() async {
  try {
    await platform.invokeMethod('openAlarmSettings');
    print("Alarm app opened successfully.");
  } on PlatformException catch (e) {
    print("Failed to open alarm settings: '${e.message}'.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ThemeConstants.pageTitle(context, "Alarm settings")),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("The Teamclock app uses the device settings to call alarms. The Alarm settings can be changed directly from the device settings. The button below will take you to the alarm settings of your device."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceBright),
                onPressed: openAlarmSettings,
                child: Text('Open Alarm Settings', style: GoogleFonts.montserrat()),
                        ),
            ),
          ]
        ),
      ),
    );
  }
}
