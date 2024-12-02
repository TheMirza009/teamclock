import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Provider%20Classes/task_manager_class.dart';
import 'package:time_slider/View/Drawer/drawer_content.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/Pomodoro%20Components/Main%20Riverpod%20Version/pomodoro_widget_riverpod.dart';
import 'package:time_slider/View/Utils/Pomodoro%20Components/Task%20Section/pomodoro_tasklist.dart';
import 'package:time_slider/View/Utils/drawerIcon.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Intiialize LoadTasks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TaskManager(ref).loadTasks();
    });

  final deleteAllTasks = IconButton(
    onPressed: () => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Clear Tasks"),
        content: const Text("Are you sure you want to delete all tasks?"),
        actions: [
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              // ref.read(taskListProvider.notifier).clearTasks(); // Call method to clear tasks
              TaskManager(ref).clearTasks();
              Navigator.of(context).pop(); // Close the dialog after clearing tasks
            },
          ),
        ],
      ),
    ),
    icon: Icon(
      Icons.delete,
      color: Theme.of(context).colorScheme.primary,
    ),
  );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: buildDrawerIconButton(context),
        title: ThemeConstants.pageTitle(context, "Pomodoro"),
        actions: [
          deleteAllTasks
        ],
      ),
      drawer: const DrawerContent(),
      body: const Column(
        children: 
        [
          PomodoroMainRiverpod(),
          PomodoroTaskList(),
        ],
      ),
    );
  }
}
