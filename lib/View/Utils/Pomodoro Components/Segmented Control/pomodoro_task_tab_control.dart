import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class TaskTabSegmentedControl extends StatelessWidget {
  final onValueChanged;
  final groupValue;
  const TaskTabSegmentedControl({
    super.key, 
    required this.onValueChanged,
    required this.groupValue});

  // int segmentedControlValue = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CupertinoSlidingSegmentedControl<int>(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        groupValue: groupValue,
        backgroundColor: Colors.transparent,
        thumbColor: Theme.of(context).colorScheme.surfaceContainer,
        children: <int, Widget>{
          0: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0,), // Adjust padding as needed
            child: Text(
              'Pending',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: ThemeConstants.getDynamicFontSize(13)),
              textAlign: TextAlign.center,
            ),
          ),
          1: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Text(
              'Completed',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: ThemeConstants.getDynamicFontSize(13)),
              textAlign: TextAlign.center,
            ),
          ),
        },
        onValueChanged: onValueChanged,
      ),
    );
  }
}
