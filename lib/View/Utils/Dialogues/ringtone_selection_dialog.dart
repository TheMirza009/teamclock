import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class RingtoneSelectionDialog extends StatefulWidget {
  final ValueChanged<String> onRingtoneSelected; // Callback to notify parent screen

  const RingtoneSelectionDialog({super.key, required this.onRingtoneSelected});

  @override
  State<RingtoneSelectionDialog> createState() => _RingtoneSelectionDialogState();
}

class _RingtoneSelectionDialogState extends State<RingtoneSelectionDialog> {
  int selectedIndex = 0; // Initial selected index is 0 (no ringtone selected)

  @override
  Widget build(BuildContext context) {
    final List<String> ringtones = [
      "Basic Alarm",
      "Fire Alarm",
      "Siren",
    ];

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
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "Select Ringtone",
                            style: GoogleFonts.montserrat(
                              fontSize: ThemeConstants.getDynamicFontSize(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200, // Adjust height as needed
                      child: ListView.builder(
                        itemCount: ringtones.length,
                        itemBuilder: (context, index) {
                          final ringtone = ringtones[index];
                          bool isSelected = selectedIndex == index;
                          return SizedBox(
                            height: 50,
                            child: ListTile(
                              leading: AnimatedOpacity(
                                opacity: isSelected ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(CupertinoIcons.check_mark, color: ThemeConstants.neutralblue),
                              ),
                              title: Text(
                                ringtone,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onTap: () {
                                widget.onRingtoneSelected(ringtone); // Notify parent when ringtone is selected

                                // Update the selected index and trigger fade animation
                                setState(() {
                                  selectedIndex = index;
                                });

                                Future.delayed(const Duration(milliseconds: 300), () => Navigator.pop(context, ringtone));
                              },
                            ),
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
