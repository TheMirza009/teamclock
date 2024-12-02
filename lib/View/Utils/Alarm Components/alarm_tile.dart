import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class AlarmTile extends ConsumerWidget {
  final StateProvider<bool> provider;
  final String title;
  final String location;
  const AlarmTile({
    super.key, 
    required this.provider, 
    required this.title,
    required this.location,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool alarmValue = ref.watch(provider);
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: ThemeConstants.timeContainerDecor(
          context: context,
          isSelected: false,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          title,
                          style: GoogleFonts.montserrat(
                            color: alarmValue
                                ? primaryColor
                                : primaryColor.withOpacity(0.3),
                            fontWeight: FontWeight.bold,
                            fontSize: ThemeConstants.getDynamicFontSize(16),
                          ),
                        ),
                      ),
                      Text(
                        location,
                        style: GoogleFonts.montserrat(
                          color: alarmValue
                            ? primaryColor
                            : primaryColor.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                          fontSize: ThemeConstants.getDynamicFontSize(12),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "06:20",
                          style: GoogleFonts.montserrat(
                            color: alarmValue
                                ? primaryColor
                                : primaryColor.withOpacity(0.3),
                            fontWeight: FontWeight.bold,
                            fontSize: ThemeConstants.getDynamicFontSize(30),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 5),
                          child: Text(
                            "AM",
                            style: GoogleFonts.montserrat(
                              color: alarmValue
                                  ? primaryColor
                                  : primaryColor.withOpacity(0.3),
                              fontWeight: FontWeight.w600,
                              fontSize: ThemeConstants.getDynamicFontSize(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.alarm,
                        color: alarmValue
                            ? primaryColor.withOpacity(0.3)
                            : primaryColor.withOpacity(0.2),
                        size: ThemeConstants.getDynamicFontSize(12),
                      ),
                      SizedBox(
                          width: ThemeConstants.getDynamicFontSize(4)),
                      Text(
                        "Today - 2:00 AM PKT   |   ",
                        style: GoogleFonts.montserrat(
                          color: primaryColor.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                          fontSize: ThemeConstants.getDynamicFontSize(8),
                        ),
                      ),
                      Text(
                        "4 hours and 45 minutes",
                        style: GoogleFonts.montserrat(
                          color: alarmValue
                              ? ThemeConstants.neutralgreen
                              : primaryColor.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                          fontSize: ThemeConstants.getDynamicFontSize(8),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: Switch(
                      inactiveTrackColor: Colors.transparent,
                      value: alarmValue,
                      onChanged: (value) =>
                          ref.read(provider.notifier).state = value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
