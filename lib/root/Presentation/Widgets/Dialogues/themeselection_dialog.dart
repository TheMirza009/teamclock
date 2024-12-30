import 'package:flutter/material.dart';

class ThemeSelectionDialog extends StatelessWidget {
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeSelectionDialog({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Light Mode'),
            onTap: () {
              onThemeChanged(ThemeMode.light);  // Pass light theme to MyApp
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Dark Mode'),
            onTap: () {
              onThemeChanged(ThemeMode.dark);  // Pass dark theme to MyApp
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('System Default'),
            onTap: () {
              onThemeChanged(ThemeMode.system);  // Pass system theme to MyApp
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
