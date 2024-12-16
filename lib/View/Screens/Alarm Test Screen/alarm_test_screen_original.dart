import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/Dependency%20Classes/notification_controller.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

  final offstageProvider = StateProvider<bool>((ref) => true); // Initially hidden
  final selectedTimeProvider = StateProvider<tz.TZDateTime?>((ref) => null); // Selected time

class AlarmTestScreen_o extends ConsumerStatefulWidget {
  const AlarmTestScreen_o({super.key});

  @override
  _AlarmTestScreenState createState() => _AlarmTestScreenState();
}

final AudioPlayer player = AudioPlayer();

void stopAlarm(WidgetRef ref) async {
  // _alarmTimer?.cancel();
  await player.stop();
  ref.read(offstageProvider.notifier).state = true; // Hide alarm icon
  ref.read(selectedTimeProvider.notifier).state = null; // Clear selected Time
}

class _AlarmTestScreenState extends ConsumerState<AlarmTestScreen_o> {
  Timer? _alarmTimer;
  DateTime _lastUpdate = DateTime.now();
  final kolkataTimeProvider = StateProvider<tz.TZDateTime>((ref) => getKolkataTime());

  @override
  void initState() {
    super.initState();
    // Start background time check (no rebuilds triggered)
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), _fireAlarm);
  }

  @override
  void dispose() {
    _alarmTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Declarations
    final kolkataTime = ref.watch(kolkataTimeProvider);
    final isOffstage = ref.watch(offstageProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final selectedTime = ref.watch(selectedTimeProvider);

    // Main BUILD Return
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            border: Border.all(color: Colors.grey, width: 3)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              // Show alarm icon based on state
              Offstage(
                offstage: isOffstage,
                child: Icon(Icons.alarm, size: 100, color: primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                'Kolkata Time:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: primaryColor),
              ),
              Text(
                '${kolkataTime.hour}:${kolkataTime.minute.toString().padLeft(2, '0')}:${kolkataTime.second.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor),
              ),

              // Display selected alarm time
              if (selectedTime != null)
                Text('${ isOffstage ? "Selected Alarm Time" : "Currently ringing"}: ${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: primaryColor),
                ) else const SizedBox.shrink(),
              
              // CupertinoButton for selecting time
              CupertinoButton(
                child: const Text('Pick Alarm Time'),
                onPressed: () => showTimePicker(context, ref, kolkataTime),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    onPressed: () => stopAlarm(ref),
                    tooltip: 'Stop Alarm',
                  ),
                  IconButton(
                    icon: const Icon(Icons.list, color: Color.fromARGB(255, 88, 198, 242)),
                    onPressed: () {
                      print(kolkataTime);
                    },
                    tooltip: 'Print Time',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static tz.TZDateTime getKolkataTime() {
    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Kolkata');
    return tz.TZDateTime.now(location);
  }

  void _fireAlarm(Timer timer) {
    final selectedTime = ref.read(selectedTimeProvider);
    final kolkataTime = ref.read(kolkataTimeProvider);

    if (selectedTime != null) {
      if (kolkataTime.hour == selectedTime.hour &&
          kolkataTime.minute == selectedTime.minute &&
          kolkataTime.second == selectedTime.second) {
        ref.read(offstageProvider.notifier).state = false; // Show alarm icon
        playAlarmSound2();
        NotificationController.showAlarmNotification();
        // NotificationController.fireScheduledNotification(selectedTime);
        // timer.cancel(); // Stop the timer after alarm goes off
      }
    }

    // Only update kolkata time in the provider every second to avoid unnecessary rebuilds
    final now = DateTime.now();
    if (now.second != _lastUpdate.second) {
      ref.read(kolkataTimeProvider.notifier).state = getKolkataTime();
      _lastUpdate = now;
    }
  }

  Future<void> showTimePicker(BuildContext context, WidgetRef ref, tz.TZDateTime currentTime) async {
    final hours = List.generate(24, (index) => index);
    final minutes = List.generate(60, (index) => index);

    // Declare selected hour and minute outside of the builder function
    int selectedHour = currentTime.hour ?? 0;
    int selectedMinute = currentTime.minute ?? 0;

    // Initialize scroll controllers with the current hour and minute
  final hourController = FixedExtentScrollController(initialItem: selectedHour);
  final minuteController = FixedExtentScrollController(initialItem: selectedMinute);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        confirmAlarm() {
          final currentTime = getKolkataTime();
          ref.read(selectedTimeProvider.notifier).state = tz.TZDateTime(
            currentTime.location,
            currentTime.year,
            currentTime.month,
            currentTime.day,
            selectedHour,
            selectedMinute,
          );
          Navigator.pop(context); // Close the time picker
        }
          
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: confirmAlarm,
                  child: const Icon(CupertinoIcons.xmark),
                ),
                Text("Select Alarm time", style: ThemeConstants.montserratBold(context),),
                CupertinoButton(
                  onPressed: confirmAlarm,
                  child: const Icon(CupertinoIcons.check_mark),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(

                    // HOUR PICKER
                    child: CupertinoPicker(
                      scrollController: hourController,
                      looping: true,
                      itemExtent: 40.0,
                      onSelectedItemChanged: (index) {
                        selectedHour = hours[index];
                      },
                      children: hours.map((e) => Text(e.toString().padLeft(2, '0'))).toList(),
                    ),
                  ),
                  Expanded(

                    // MINUTE PICKER
                    child: CupertinoPicker(
                      scrollController: minuteController,
                      looping: true,
                      itemExtent: 40.0,
                      onSelectedItemChanged: (index) {
                        selectedMinute = minutes[index];
                      },
                      children: minutes.map((e) => Text(e.toString().padLeft(2, '0'))).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> playAlarmSound2() async {
    try {
      await player.setAsset('Assets/sound/alarms/Basic Alarm.mp3');
      player.setLoopMode(LoopMode.one);
      await player.play();
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }
}

// Make this into a model/class/item object that can be called with a different alarm each.
// The current AlarmTestScreen page, make it into a "list" of atleast 3 different alarms.
// One from Pakistan, one from Kolkata and one from Kabul.

// Make it also such that the timezone can be selected for the alarm.
// I'm looking forward to a clean, optimized and simplified class object which calls static methods such as stopalarm from another class called AlarmFunctions.

// Looking forward to it.