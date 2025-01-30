import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:teamclock/core/utilities/ringtones_class.dart';
import 'package:teamclock/core/theme/theme_constants.dart';

class RingtoneSelectionDialog extends StatefulWidget {
  final ValueChanged<String> onRingtoneSelected; // Callback to notify parent screen

  const RingtoneSelectionDialog({super.key, required this.onRingtoneSelected});

  @override
  State<RingtoneSelectionDialog> createState() => _RingtoneSelectionDialogState();
}

class _RingtoneSelectionDialogState extends State<RingtoneSelectionDialog> {
  int selectedIndex = 0; // Initial selected index is 0 (no ringtone selected)
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer(); // Initialize the player
  }

  @override
  void dispose() {
    player.stop(); // Stop the sound when the dialog is disposed (closed)
    player.dispose(); // Properly dispose the player
    super.dispose();
  }

  // Play selected ringtone sound
  Future<void> playAlarmSound(String path) async {
    try {
      await player.setAsset(path); // Set the ringtone asset
      player.setLoopMode(LoopMode.off); // Ensure it plays only once
      await player.play(); // Play the sound
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> ringtones = Ringtones.allRingtones.toList();

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
                      height: 300, // Adjust height as needed
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: Radius.circular(15),
                        child: ListView.builder(
                          
                          itemCount: ringtones.length + 1, // Add one more item for the extra space
                          itemBuilder: (context, index) {
                        
                            // Space at the end of the list
                            if (index == ringtones.length) return const SizedBox(height: 50); 
                        
                            final ringtone = ringtones[index];
                            bool isSelected = selectedIndex == index;
                            return SizedBox(
                              height: 50,
                              child: ListTile(
                                leading: AnimatedOpacity(
                                  opacity: isSelected ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const Icon(CupertinoIcons.check_mark,
                                      color: ThemeConstants.neutralblue),
                                ),
                                title: Text(
                                  Ringtones.extractTitle(ringtone),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onTap: () async {
                                  await player.stop();   // Stop previous sound before playing the new one
                                  playAlarmSound(ringtone);
                                  setState(() { // Update the selected index and trigger fade animation
                                    selectedIndex = index;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )

                    // const SizedBox(height: 50),
                  ],
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.onRingtoneSelected(ringtones[selectedIndex]); // Notify parent when ringtone is selected
                      await player.stop();
                    },
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                      player.stop(); // Stop the sound when closing the dialog
                    },
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
