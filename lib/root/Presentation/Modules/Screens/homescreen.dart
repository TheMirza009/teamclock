import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Alarms/view/alarm_list_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/view/pomodoro_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Settings/settings_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/timezone_screen.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/port_test.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/testscreen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          height: 60,
          iconSize: 30,
          activeColor: ThemeConstants.neutralblue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock),
              // label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.timelapse),
              // label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.alarm),
              // label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              // label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const TimezonesScreen();
            case 1:
              return const PomodoroScreen();
            case 2:
              return const AlarmListScreen();
            case 3:
            default:
              return const TestScreen(); 
              // return PortTestScreen(); 
              // return const SettingsScreen();
          }
        },
      ),
    );
  }
}

class TabScreen extends StatelessWidget {
  final String title;

  const TabScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.red,
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}