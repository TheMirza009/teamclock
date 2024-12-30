import 'package:flutter/material.dart';

class DualSlider extends StatefulWidget {
  final double meterInitialValue;
  final double centimeterInitialValue;
  final Function(double) onMeterChanged;
  final Function(double) onCentimeterChanged;

  const DualSlider({
    required this.meterInitialValue,
    required this.centimeterInitialValue,
    required this.onMeterChanged,
    required this.onCentimeterChanged,
    super.key,
  });

  @override
  _DualSliderState createState() => _DualSliderState();
}

class _DualSliderState extends State<DualSlider> {
  late double meterValue;
  late double centimeterValue;

  @override
  void initState() {
    super.initState();
    meterValue = widget.meterInitialValue;
    centimeterValue = widget.centimeterInitialValue;
  }

  void _updateMeterValue(double value) {
    setState(() {
      meterValue = value;
      centimeterValue = value * 100; // Assuming 1 meter = 100 centimeters
      widget.onMeterChanged(meterValue);
      widget.onCentimeterChanged(centimeterValue);
    });
  }

  void _updateCentimeterValue(double value) {
    setState(() {
      centimeterValue = value;
      meterValue = value / 100; // Assuming 1 meter = 100 centimeters
      widget.onMeterChanged(meterValue);
      widget.onCentimeterChanged(centimeterValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Meters: ${meterValue.toStringAsFixed(2)} m',
          style: const TextStyle(fontSize: 18),
        ),
        Slider(
          min: 0,
          max: 10,
          value: meterValue,
          onChanged: _updateMeterValue,
        ),
        const SizedBox(height: 20),
        Text(
          'Centimeters: ${centimeterValue.toStringAsFixed(2)} cm',
          style: const TextStyle(fontSize: 18),
        ),
        Slider(
          min: 0,
          max: 1000,
          value: centimeterValue,
          onChanged: _updateCentimeterValue,
        ),
      ],
    );
  }
}
