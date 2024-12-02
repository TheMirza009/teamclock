import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/Model/Provider%20Classes/theme_class.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class ThemeSelectionDialogIOS extends StatelessWidget {
  // final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeSelectionDialogIOS({super.key, 
  // required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Declarations
    final primarycolor = Theme.of(context).colorScheme.primary;
    final normaltext = GoogleFonts.montserrat(fontSize: ThemeConstants.getDynamicFontSize(13), color: primarycolor);

    // Row Widget
    Widget rowTile({required List<Widget> children}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        return CupertinoActionSheet(
          title: Text('Select Theme', style: normaltext),
          message: Text('Choose a theme for your app.', style: normaltext),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
                Navigator.of(context).pop();
              },
              child: rowTile(
                  children: [
                    Text( 'Light Mode', style: normaltext),
                    const Icon( CupertinoIcons.sun_max, color: CupertinoColors.systemYellow ),
                  ],
                )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
                Navigator.of(context).pop();
              },
              child: rowTile(children: [Text('Dark Mode', style: normaltext,),
                  const Icon(CupertinoIcons.moon_stars, color: CupertinoColors.systemBlue),])
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
                Navigator.of(context).pop();
              },
              child: rowTile(children: [
                  Text('System Default', style: normaltext,),
                  const Icon(CupertinoIcons.device_phone_portrait, color: CupertinoColors.systemGreen),
                ],)
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
        );
      }
    );
  }
}
