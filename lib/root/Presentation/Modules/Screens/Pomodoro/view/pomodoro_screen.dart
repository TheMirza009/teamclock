import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/viewmodel/task_manager_class.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawer_content.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/Pomodoro%20Dialogues/new_task_dialogue_ios.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/simple_cupertino_dialogue.dart';
import 'package:time_slider/root/Presentation/Widgets/Pomodoro%20Components/Main%20Riverpod%20Version/pomodoro_widget_riverpod.dart';
import 'package:time_slider/root/Presentation/Widgets/Pomodoro%20Components/Task%20Section/pomodoro_tasklist.dart';
import 'package:time_slider/root/Presentation/Modules/Drawer/drawerIcon.dart';
import 'package:time_slider/root/Presentation/Widgets/svgIcon.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeContext = Theme.of(context);
    final primaryColor = themeContext.colorScheme.primary;

    // Intiialize LoadTasks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TaskManager(ref).loadTasks();
    });

  // final deleteAllTasks = IconButton(
  //   onPressed: () => 
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text("Clear Tasks"),
  //       content: const Text("Are you sure you want to delete all tasks?"),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: const Text('No'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //         CupertinoDialogAction(
  //           child: const Text('Yes'),
  //           onPressed: () {
  //             // ref.read(taskListProvider.notifier).clearTasks(); // Call method to clear tasks
  //             TaskManager(ref).clearTasks();
  //             Navigator.of(context).pop(); // Close the dialog after clearing tasks
  //           },
  //         ),
  //       ],
  //     ),
  //   ),
  //   icon: Icon(
  //     Icons.delete,
  //     color: Theme.of(context).colorScheme.primary,
  //   ),
  // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => cupertinoSimpleDialogue(
            context: context,
            title: "Clear Tasks",
            content: "Are you sure you want to delete all tasks?",
            onYesPressed: () async {
              TaskManager(ref).clearTasks();
            },
          ),
          icon: svgIcon(color: primaryColor),
        ),
        title: ThemeConstants.pageTitle(context, "Pomodoro"),
        actions: [
          IconButton(
            onPressed: () => showCupertinoDialog(
              context: context,
              builder: (context) {
                // return NewTaskDialogue(ref: ref);
                return TextDialogueCupertino(ref: ref);
              }),
            icon: Icon(CupertinoIcons.add, color: primaryColor),
          ),
        ],
      ),
      drawer: const DrawerContent(),
      body: const SingleChildScrollView(
        child: Column(
          children: 
          [
            PomodoroMainRiverpod(),
            PomodoroTaskList(),
          ],
        ),
      ),
    );
  }
}
