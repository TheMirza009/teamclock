import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Widget timeAndPlaceFromTimeZone({
  required BuildContext context,
  required String timeZone,
  required int dynamicMinutes,
  bool isFirst = true,
  final selectedTimeZone = "Asia/Karachi",
  final onDeletePressed,
  bool showSeconds = false,
  bool isMini = false,
}) {
  // Text sizes
  double locationTextSize = 15;
  double gmttextsize = (locationTextSize/1.3);

  // Strings
  String timedifference = "";
  String timezone = timeZone.toString();

   // Get the current time in that timezone
  final current = tz.TZDateTime.now(tz.getLocation(timezone)).add(Duration(minutes: dynamicMinutes));
  final location = TimeFunctions.getCityAndCountryFromTimezone(timezone); // Location Names for display
  final offset = TimeFunctions.getTimezoneOffset(timezone); // GMT Offset for display

  // Styling
  bool isLightTheme = Theme.of(context).colorScheme.primary != ThemeConstants.darkTitle;
  final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.white;
  final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

  // Determine if it's AM or PM
  final isAM = current.hour < 12;
  final hour12 = current.hour % 12; // Convert to 12-hour format
  final displayHour = hour12 == 0 ? 12 : hour12; // Ensure hour 0 is displayed as 12

  // Time display widget
  final timeDisplay = Text(
  "${displayHour < 10 ? '0$displayHour' : displayHour}:${current.minute.toString().padLeft(2, '0')}" 
  "${showSeconds ? ':${current.second < 10 ? '0${current.second}' : current.second}' : ''}",
  style: TextStyle(fontSize: 70, color: titleColor),
);

  final dateDisplay = Text(
    "${DateFormat('EEEE').format(current)} - ${DateFormat.yMMMMEEEEd().format(current).split(',').sublist(1).join(',')}",
    style: TextStyle(
      fontSize: 18,
      color: subtitleColor,
    ),
  );

  // MINI WIDGET SETTINGS
  double minifontsize = 13;
  final timeDisplayMini = Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Text(
      "$displayHour:${(current.minute).toString().padLeft(2, '0')}${showSeconds ? ":${current.second < 10 ? ("0${current.second}") : current.second.toString()}" : ""} ${isAM ? 'AM' : 'PM'}",
      style: TextStyle(fontSize: minifontsize + 5, color: titleColor),
    ),
  );

  String calculateTimeDifference() {
    final location1 = tz.getLocation(selectedTimeZone);
    final location2 = tz.getLocation(timezone);

    // Get the current time in both time zones
    final currentTimeInLocation1 = tz.TZDateTime.now(location1);
    final currentTimeInLocation2 = tz.TZDateTime.now(location2);

    // Calculate the offsets in minutes
    final differenceInMinutes =
    currentTimeInLocation1.timeZoneOffset.inMinutes - currentTimeInLocation2.timeZoneOffset.inMinutes;

    // Convert back to hours and minutes
    final hours = differenceInMinutes ~/ 60;
    final minutes = differenceInMinutes % 60;

    // Return empty string for 0h 0m
    if (hours == 0 && minutes == 0) {
      return "";
    }

    // Construct the difference string
    timedifference = '${hours >= 0 ? '+' : '-'}${hours.abs()}h ${minutes.abs()}m';
    return timedifference;
  }

 Widget timedifferencecontainer() {
  bool isLightTheme = Theme.of(context).colorScheme.primary != ThemeConstants.darkTitle;
  String differenceString = calculateTimeDifference();
  final isPositive = differenceString.startsWith('+');
    return Container(
      decoration: BoxDecoration(
        color: differenceString == ""
            ? Colors.transparent
            : ( isLightTheme ? const Color.fromARGB(64, 153, 163, 168) :  const Color.fromARGB(64, 68, 76, 80)),
            // : (isPositive
            //     ? const Color.fromARGB(64, 153, 163, 168)
            //     : const Color.fromARGB(125, 212, 178, 178)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          differenceString,
          style: GoogleFonts.montserrat(
            fontSize: ThemeConstants.getDynamicFontSize(12),
            // color: isLightTheme ? const Color.fromARGB(137, 0, 0, 0) : ThemeConstants.darkTitle,
            // color: isPositive ? const Color.fromARGB(255, 252, 87, 87) : ThemeConstants.neutralgreen,
            color: !isPositive ? (isLightTheme ? ThemeConstants.neutralred : ThemeConstants.darkerror) : const Color.fromARGB(255, 56, 172, 192),
          ),
        ),
      ),
    );
  }


  return !isMini
      ? Column(
          children: [
            Text(
              "$location | $offset", // Display the timezone name
              style: TextStyle(fontSize: 20, color: titleColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                timeDisplay,
                const SizedBox(width: 10),
                Text(
                  isAM ? 'AM' : 'PM',
                  style: TextStyle(fontSize: 30, color: titleColor),
                ),
              ],
            ),
            const SizedBox(height: 2),
            dateDisplay,
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // !isFirst 
                // ? IconButton(onPressed: onDeletePressed, icon: const Icon(Icons.delete)) 
                // : SizedBox(width: ThemeConstants.getDynamicFontSize(45),),
                !isFirst 
                ? SizedBox(width: ThemeConstants.getDynamicFontSize(10),)
                : SizedBox(width: ThemeConstants.getDynamicFontSize(10),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ThemeConstants.getDynamicFontSize(180),
                      child: Text(
                        location, // Display the timezone name
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: ThemeConstants.getDynamicFontSize(locationTextSize),
                          color: isLightTheme ? ThemeConstants.lightTitle : ThemeConstants.darkTitle,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          // "$offset | ${calculateTimeDifference()}", // Display the timezone name
                          offset, // Display the timezone name
                          style: GoogleFonts.montserrat(
                            fontSize: ThemeConstants.getDynamicFontSize(gmttextsize),
                            color:isLightTheme ?  ThemeConstants.lightSubtitle : ThemeConstants.darkSubtitle,
                          ),
                        ),
                        const SizedBox(width: 8,),
                        timedifferencecontainer(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                timeDisplayMini,
              ],
            ),
          ],
        );
}
