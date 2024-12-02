import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/timezone_states.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/ViewModel/timefunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTimezoneDialog extends StatefulWidget {
  final ValueChanged<String> onTimezoneAdded; // Callback to notify parent screen

  const AddTimezoneDialog({super.key, required this.onTimezoneAdded});

  @override
  State<AddTimezoneDialog> createState() => _AddTimezoneDialogState();
}

class _AddTimezoneDialogState extends State<AddTimezoneDialog> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode(); // Create a FocusNode
  List<String> filteredTimeZones = [];

  @override
  void initState() {
    super.initState();
    filteredTimeZones = tz.timeZoneDatabase.locations.keys.toList(); // Initialize with all time zones
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request focus after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  void filterTimeZones(String search) {
    final query = search.trim().toLowerCase(); // Trim unnecessary spaces
    setState(() {
      if (query.isEmpty) {
        filteredTimeZones = tz.timeZoneDatabase.locations.keys.toList();
      } else {
        filteredTimeZones = tz.timeZoneDatabase.locations.keys.where((timeZone) {
          String cityAndCountry = TimeFunctions.replaceLongWords(TimeFunctions.getCityAndCountryFromTimezone(timeZone).toLowerCase());
          String offset = TimeFunctions.getTimezoneOffset(timeZone).trim(); // Trim offset for consistency
          String offsetWithoutGMT = offset.replaceAll('GMT', '').trim();

          // Check if either the timezone, city and country, or offset matches the search query
          return timeZone.toLowerCase().contains(query) ||
            cityAndCountry.contains(query) ||
            offset.toLowerCase().contains(query) ||
            offsetWithoutGMT.contains(query); // Check without 'GMT'
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 5),
                      child: TextField(
                        controller: searchController,
                        focusNode: focusNode,
                        onChanged: (search) => filterTimeZones(search),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.timelapse),
                          hintText: "City or Country",
                          hintStyle: GoogleFonts.montserrat(fontSize: ThemeConstants.getDynamicFontSize(14), fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300, // Set a fixed height for the list
                      child: ListView.builder(
                        itemCount: filteredTimeZones.length,
                        itemBuilder: (context, index) {
                          final currentItem = filteredTimeZones[index];
                          bool isAlreadyAdded = TimezoneStates.timezoneselections.contains(currentItem);
                          String location = TimeFunctions.replaceLongWords(TimeFunctions.getCityAndCountryFromTimezone(currentItem));
                          String offset = TimeFunctions.getTimezoneOffset(currentItem);
                          return ListTile(
                            enabled: !isAlreadyAdded,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: ThemeConstants.getDynamicFontSize(130),
                                  child: Text( 
                                    location,
                                    maxLines: 2, // Limit to 2 lines
                                    overflow: TextOverflow.ellipsis,
                                    style: !isAlreadyAdded 
                                      ? Theme.of(context).textTheme.labelSmall 
                                      : Theme.of(context).textTheme.displaySmall,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: !isAlreadyAdded 
                                      ? Theme.of(context).colorScheme.surfaceContainerHighest 
                                      : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(offset, style: TextStyle(
                                   fontSize: ThemeConstants.getDynamicFontSize(13),
                                   color: !isAlreadyAdded 
                                     ? Theme.of(context).colorScheme.onSecondary 
                                     : Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                   ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              widget.onTimezoneAdded(currentItem);  // Notify parent when timezone is added
                              Navigator.pop(context, currentItem);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
