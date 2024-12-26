import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/hive_class.dart';
import 'package:time_slider/Model/settings_states.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/ViewModel/timezone_functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneMainUI extends ConsumerStatefulWidget {
  final String selectedTimeZone;
  final Widget slider;
  final onResetPressed;
  int initialCounter;
  TimeZoneMainUI({
    super.key,
    required this.selectedTimeZone,
    required this.initialCounter,
    required this.slider,
    required this.onResetPressed,
  });

  @override
  _TimeZoneMainUIState createState() => _TimeZoneMainUIState();
}

class _TimeZoneMainUIState extends ConsumerState<TimeZoneMainUI> {
  late int counter;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    counter = widget.initialCounter;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(SettingsStates.showSeconds))  _startTimer();
    final currentTime = tz.TZDateTime.now(tz.getLocation(widget.selectedTimeZone)).add(Duration(minutes: widget.initialCounter));
    final formattedDate = TimezoneFunctions.formatDate(currentTime);
    final formattedTime = TimezoneFunctions.formatTime(
      current: currentTime, 
      context: context, 
      showSeconds: ref.watch(SettingsStates.showSeconds), 
      show12HourFormat: ref.watch(SettingsStates.show12HourFormat),
      );
    final dayOfWeek = formattedDate['dayOfWeek']; // Correctly access the key
    final fullDate = formattedDate['fullDate']; // Correctly access the key
    final location = TimezoneFunctions.getCityAndCountryFromTimezone(widget.selectedTimeZone);
    final offset = TimezoneFunctions.getTimezoneOffset(widget.selectedTimeZone);
    final currentDay = (TimezoneFunctions.formatDate(tz.TZDateTime.now(tz.getLocation(widget.selectedTimeZone))))['dayOfWeek'];
    final nextday = (TimezoneFunctions.formatDate(
      tz.TZDateTime.now(tz.getLocation(widget.selectedTimeZone))
      .add(const Duration(hours: 24))))['dayOfWeek'];

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: ThemeConstants.timeContainerDecor(
          context: context, isSelected: false),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 25, bottom: 10, right: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dayOfWeek!,
                        style: dayOfWeek == currentDay
                            ? TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary)
                            : (nextday == dayOfWeek
                                ? const TextStyle(color: ThemeConstants.neutralgreen)
                                : const TextStyle(
                                    color: Color.fromARGB(
                                        255, 218, 97, 97)))),
                    Text(fullDate!,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
            ),

            // MAIN TIME DISPLAY
            InkWell(
              onTap: () async {
                // await  WidgetsFlutterBinding.ensureInitialized();
                // String localTimezone = await FlutterTimezone.getLocalTimezone();
                // print("Local Timezone: $localTimezone");
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: formattedTime,
              ),
            ),

            // TIMEZONE DETAILS
            Transform.translate(
              offset: const Offset(0, 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text(offset,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(width: 1),
                    _buildResetButton(context),
                  ],
                ),
              ),
            ),
            // Slider(
            //   max: 1440,
            //   min: -1440,
            //   value: widget.counter.toDouble(),
            //   onChanged: (value) {
            //     setState(() {
            //       widget.counter = value.toInt();
            //     });
            //   },
            // ),
            widget.slider,
            _buildCounterDisplay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    double iconsize = ThemeConstants.getDynamicFontSize(35);
    return widget.initialCounter == 0
        ? SizedBox(height: iconsize)
        : Transform.translate(
            offset: const Offset(-4, -12),
            child: SizedBox(
              height: iconsize,
              width: iconsize,
              child: IconButton(
                splashRadius: 20,
                style: IconButton.styleFrom(
                  // fixedSize: Size(1, 1), // Set the size of the button
                  iconSize: iconsize / 1.6,
                ),
                onPressed: widget.onResetPressed,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.error,
                  fill: 0.9,
                ),
              ),
            ),
          );
  }

  Widget _buildCounterDisplay(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ThemeConstants.getDynamicFontSize(20.0)),
      child: Container(
        decoration: BoxDecoration(
          // color: widget.counter == 0 ? Colors.transparent : Theme.of(context).colorScheme.surfaceTint,
          color: widget.initialCounter == 0
              ? Colors.transparent
              : ThemeConstants.neutralgrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
          child: Text(
            TimezoneFunctions.formatCounter(widget.initialCounter),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
