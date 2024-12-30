import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Define a provider for the theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// StateNotifier to handle theme mode changes
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    loadTheme(); // Load theme mode from Hive
  }

  void setTheme(ThemeMode themeMode) async {
    state = themeMode; // Update the theme mode
    await Hive.box('timezones').put('themeMode', themeMode.index); // Save to Hive
  }

  Future<void> loadTheme() async {
    final box = Hive.box('timezones');
    final themeIndex = box.get('themeMode', defaultValue: ThemeMode.system.index);
    state = ThemeMode.values[themeIndex]; // Load the saved theme mode
  }
}
