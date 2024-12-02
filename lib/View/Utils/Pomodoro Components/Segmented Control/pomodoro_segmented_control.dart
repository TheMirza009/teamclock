import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainSegmentedControls extends StatefulWidget {
  int timerTab;
  final ValueChanged<int> onSegmentChanged; // Callback to notify parent

  MainSegmentedControls({super.key, required this.timerTab, required this.onSegmentChanged});

  @override
  _MainSegmentedControlsState createState() => _MainSegmentedControlsState();
}

class _MainSegmentedControlsState extends State<MainSegmentedControls> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320, // Adjust as needed
      child: CupertinoSlidingSegmentedControl<int>(
        padding: const EdgeInsets.all(0),
        groupValue: widget.timerTab,
        backgroundColor: Colors.transparent,
        thumbColor: Theme.of(context).colorScheme.surfaceBright,
        children: const <int, Widget>{
          0: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Text('FOCUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5,), textAlign: TextAlign.center,),
          ),
          1: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Text('Short Break', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5), textAlign: TextAlign.center),
          ),
          2: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Long Break', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5), textAlign: TextAlign.center),
          ),
        },
        onValueChanged: (int? value) {
          if (value != null) {
            widget.onSegmentChanged(value); // Notify parent about change
          }
        },
      ),
    );
  }
}
