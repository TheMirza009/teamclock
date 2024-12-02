import 'package:flutter/material.dart';
import 'package:time_slider/View/Utils/TimeZone%20components/currenttimegetter.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';

class TimeZoneWidget extends StatefulWidget {
  final String timezone;
  // final int dynamicMinutes;
  // int counter;
  TimeZoneWidget({
    super.key,
    required this.timezone,
    // required this.dynamicMinutes,
    // required this.counter,
  });

  @override
  State<TimeZoneWidget> createState() => _TimeZoneWidgetState();
}

class _TimeZoneWidgetState extends State<TimeZoneWidget> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: ThemeConstants.timeContainerDecor(
          context: context, isSelected: false),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            timeAndPlaceFromTimeZone(
              context: context,
              dynamicMinutes: counter,
              timeZone: widget.timezone,
              showSeconds: false,
            ),
            Slider(
              max: 1440,
              min: -1440,
              value: counter.toDouble(),
              onChanged: (value) {
                setState(() {
                  counter =
                      value.toInt(); // Update the state with the new value
                });
                print(value); // Print the value to the console
              },
            ),
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Conditional Rendering of the RESET BUTTON
                    counter == 0
                        ? const SizedBox(height: 40)
                        : IconButton.outlined(
                            onPressed: () => setState(() {
                              counter = 0;
                            }),
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ],
                ),
            Text(
                  TimeFunctions.formatCounter(counter),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
          ],
        ),
      ),
    );
  }
}
