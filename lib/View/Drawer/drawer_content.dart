import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_slider/View/Screens/Alarm%20Test%20Screen/alarm_list_screen.dart';
import 'package:time_slider/View/Screens/settings_screen.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_alarm_screen.dart';
import 'package:time_slider/View/Screens/Timezone/timezone_screen.dart';
import 'package:time_slider/View/Screens/pomodoro_screen.dart';
import 'package:time_slider/View/Screens/stopwatch_screen.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class DrawerContent extends StatelessWidget {
  final Function(ThemeMode)? onThemeChanged;
  const DrawerContent({super.key, this.onThemeChanged});

  @override
  Widget build(BuildContext context) {

    void navigation(BuildContext context, Widget targetPage) {
      String? currentRouteName = ModalRoute.of(context)?.settings.name;
      String targetRouteName = targetPage.runtimeType.toString();

      if (currentRouteName == targetRouteName) {
        // Navigator.pop(context); // Close the drawer
        Scaffold.of(context).closeDrawer();
      } else {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => targetPage,
            settings: RouteSettings(name: targetRouteName),
          ),
        );
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: ThemeConstants.getDynamicFontSize(70)),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('Timezones', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const TimezonesScreen());},
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.timelapse),
            title: Text('Pomodoro', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const PomodoroScreen());
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.stopwatch),
            title: Text('Stopwatch', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, StopwatchScreen());
              },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.alarm),
            title: Text('Alarms', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const AlarmListScreen());
              // navigation(context, const AlarmScreen());
              },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.gear),
            title: Text('Settings', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const SettingsScreen());
              },
          ),
        ],
      ),
    );
  }
}
