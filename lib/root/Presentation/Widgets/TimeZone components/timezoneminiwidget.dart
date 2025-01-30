import 'package:flutter/material.dart';
import 'package:teamclock/core/theme/theme_constants.dart';
import 'package:teamclock/root/Presentation/Widgets/TimeZone%20components/currenttimegetter.dart';

class TimeZoneMiniWidget extends StatelessWidget {
  final int dynamicMinutes;
  final String timezone;
  final onDeletePressed;
  final selectedTimeZone;
  final bool isSelected;
  final bool isFirst;
  const TimeZoneMiniWidget({
    super.key,
    required this.dynamicMinutes,
    required this.timezone,
    required this.onDeletePressed,
    required this.isSelected,
    required this.selectedTimeZone,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: ThemeConstants.timeContainerDecor(context: context, isSelected: isSelected),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: timeAndPlaceFromTimeZone(
            context: context,
            timeZone: timezone,
            selectedTimeZone: selectedTimeZone,
            dynamicMinutes: dynamicMinutes,
            isMini: true,
            showSeconds: false,
            onDeletePressed: onDeletePressed,
            isFirst: isFirst,
            // selectedTimeZone: "Asia/Karachi",
          ),
        ),
      ),
    );
  }
}
