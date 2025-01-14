import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/view/alarm_list_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Settings/settings_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/timezone_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/view/pomodoro_screen.dart';
import 'package:time_slider/core/theme/theme_constants.dart';

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

          // Timezones tile
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('Timezones', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const TimezonesScreen());},
          ),

          // Pomodoro tile
          ListTile(
            leading: const Icon(CupertinoIcons.timelapse),
            title: Text('Pomodoro', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const PomodoroScreen());
            },
          ),

          // Alarms Tile
          ListTile(
            leading: const Icon(CupertinoIcons.alarm),
            title: Text('Alarms', style: Theme.of(context).textTheme.displayMedium),
            onTap: () { 
              Navigator.pop(context);
              navigation(context, const AlarmListScreen());
              // navigation(context, const AlarmScreen());
              },
          ),

          // Settings tile
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
