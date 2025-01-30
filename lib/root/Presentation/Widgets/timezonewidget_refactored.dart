import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:teamclock/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';

class TimeZoneDisplay extends StatelessWidget {
  final String timeZone;
  final int dynamicMinutes;
  final String selectedTimeZone;
  final VoidCallback? onDeletePressed;
  final bool showSeconds;
  final bool isMini;

  const TimeZoneDisplay({
    super.key,
    required this.timeZone,
    required this.dynamicMinutes,
    this.selectedTimeZone = "Asia/Karachi",
    this.onDeletePressed,
    this.showSeconds = false,
    this.isMini = false,
  });

  @override
  Widget build(BuildContext context) {
    final current = tz.TZDateTime.now(tz.getLocation(timeZone)).add(Duration(minutes: dynamicMinutes));
    final location = TimezoneFunctions.getCityAndCountryFromTimezone(timeZone);
    final offset = TimezoneFunctions.getTimezoneOffset(timeZone);

    return isMini ? _buildMiniWidget(context, current, location, offset) : _buildFullWidget(context, current, location, offset);
  }

  Widget _buildFullWidget(BuildContext context, tz.TZDateTime current, String location, String offset) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.white;
    final timeDisplay = _formatTime(context, current);

    return Column(
      children: [
        Text("$location | $offset", style: TextStyle(fontSize: 20, color: titleColor)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            timeDisplay,
            const SizedBox(width: 10),
            Text(current.hour < 12 ? 'AM' : 'PM', style: TextStyle(fontSize: 30, color: titleColor)),
          ],
        ),
        const SizedBox(height: 2),
        _buildDateDisplay(current, context),
      ],
    );
  }

  Widget _buildMiniWidget(BuildContext context, tz.TZDateTime current, String location, String offset) {
    // final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.white;
    final timeDisplayMini = _formatMiniTime(context, current);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(onPressed: onDeletePressed, icon: const Icon(Icons.delete)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: Theme.of(context).textTheme.headlineMedium),
                Text(offset, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
        Row(children: [timeDisplayMini]),
      ],
    );
  }

  Widget _buildDateDisplay(tz.TZDateTime current, BuildContext context) {
    final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final dateDisplay = Text(
      "${DateFormat('EEEE').format(current)} - ${DateFormat.yMMMMEEEEd().format(current).split(',').sublist(1).join(',')}",
      style: TextStyle(fontSize: 18, color: subtitleColor),
    );
    return dateDisplay;
  }

  Widget _formatTime(BuildContext context, tz.TZDateTime current) {
    final displayHour = current.hour % 12 == 0 ? 12 : current.hour % 12;
    final formattedHour = displayHour < 10 ? '0$displayHour' : displayHour.toString();
    final formattedMinutes = current.minute.toString().padLeft(2, '0');

    return Text(
      "$formattedHour:$formattedMinutes${showSeconds ? ':${current.second.toString().padLeft(2, '0')}' : ''}",
      style: TextStyle(fontSize: 70, color: Theme.of(context).textTheme.titleLarge?.color),
    );
  }

  Widget _formatMiniTime(BuildContext context, tz.TZDateTime current) {
    final displayHour = current.hour % 12 == 0 ? 12 : current.hour % 12;
    final formattedHour = displayHour.toString();
    final formattedMinutes = current.minute.toString().padLeft(2, '0');
    final amPm = current.hour < 12 ? 'AM' : 'PM';

    return Text(
      "$formattedHour:$formattedMinutes $amPm",
      style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.titleLarge?.color),
    );
  }

  String calculateTimeDifference() {
    tz.initializeTimeZones();
    final difference = tz.TZDateTime.now(tz.getLocation(timeZone))
        .difference(tz.TZDateTime.now(tz.getLocation(selectedTimeZone)));

    return 'Time difference: ${difference.inHours}h ${difference.inMinutes.remainder(60)}m';
  }
}
