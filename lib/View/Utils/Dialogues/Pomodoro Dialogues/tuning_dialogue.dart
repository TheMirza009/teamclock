import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class TuningDialogue extends ConsumerWidget {
  const TuningDialogue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: ThemeConstants.screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             CupertinoButton(
              onPressed: () {
                print("Focus duration selected: 25 minutes");
                Navigator.pop(context); // Close the dialog
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Focus duration", style: GoogleFonts.montserrat()),
                  const SizedBox(width: 30,),
                  Text("25 Minutes  >", style: GoogleFonts.montserrat()),
                ],
              ),
            ),
             CupertinoButton(
              onPressed: () {
                print("Focus duration selected: 25 minutes");
                Navigator.pop(context); // Close the dialog
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Focus duration", style: GoogleFonts.montserrat()),
                  const SizedBox(width: 30,),
                  Text("25 Minutes  >", style: GoogleFonts.montserrat()),
                ],
              ),
            ),
             CupertinoButton(
              onPressed: () {
                print("Focus duration selected: 25 minutes");
                Navigator.pop(context); // Close the dialog
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Focus duration", style: GoogleFonts.montserrat()),
                  const SizedBox(width: 30,),
                  Text("25 Minutes  >", style: GoogleFonts.montserrat()),
                ],
              ),
            ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: const Size(double.maxFinite, 50),
              padding: const EdgeInsets.all(0)),
            onPressed: () {
              
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
    );
  }
}