import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/providers/pomodoro_states.dart';
import 'package:time_slider/core/theme/theme_constants.dart';
import 'package:time_slider/root/Presentation/Widgets/Dialogues/Pomodoro%20Dialogues/new_task_dialogue_ios.dart';
import 'package:time_slider/root/Presentation/Widgets/Pomodoro%20Components/Segmented%20Control/pomodoro_task_tab_control.dart';
import 'package:time_slider/root/Presentation/Widgets/Pomodoro%20Components/Task%20Section/pomodoro_task_item.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/viewmodel/pomodoro_functions.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Timezone/viewmodel/timezone_functions.dart';

class PomodoroTaskList extends ConsumerWidget {
  const PomodoroTaskList({super.key});

  @override
Widget build(BuildContext context, WidgetRef ref) {    // Watch the providers to get the tasks
    final pendingTasks = ref.watch(PomodoroStates.pendingTasksProvider);
    final completedTasks = ref.watch(PomodoroStates.completedTasksProvider);
    int currentTab = ref.watch(PomodoroStates.taskSegmentControlValue);

    // Listen to timer changes directly in the build method
     // Listen to timer changes directly using ref.listen
    // ref.listen<int>(PomodoroStates.timerNotifierProvider, (previous, current) {
    //   if (current >= 3600) {
    //     debugPrint("Timer value reached or exceeded 3600 seconds!");
    //     ref.read(PomodoroStates.containerHeight.notifier).state = 0.45;
    //   } else {
    //     debugPrint("Timer value less than 3600 seconds!");
    //     ref.read(PomodoroStates.containerHeight.notifier).state = 0.53;
    //   }
    // });


    // Determine which list to show based on the current tab
    List<Map<String, dynamic>> selectedList =
        currentTab == 0 ? pendingTasks : completedTasks;

    Widget listEmptyText = currentTab == 0 && pendingTasks.isEmpty
        ? const SizedBox.shrink()
        : currentTab == 1 && completedTasks.isEmpty
            ? Padding(
                padding: EdgeInsets.only(top: ThemeConstants.screenHeight * 0.2),
                child: Text(
                  "Completed tasks will appear here.",
                  style: ThemeConstants.notBoldText(context),
                ),
              )
            : const SizedBox.shrink();

    // Main UI
    return Column(
      children: [
        TaskTabSegmentedControl(
          groupValue: currentTab,
          onValueChanged: (int? value) {
            if (value != null) {
              ref.read(PomodoroStates.taskSegmentControlValue.notifier).state = value;
            }
          },
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8),
          child: SizedBox(
            height: ThemeConstants.screenHeight * 0.475 - 59,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Display empty text message if no tasks are present
                  if (selectedList.isEmpty) listEmptyText
                  else
                    // Display tasks from the selected list
                    ...selectedList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final task = entry.value;
                      final itemText = task['text'];
                      final itemValue = task['value'];
                      final itemTime = TimezoneFunctions.formatTimeFromDateTime(task['time']) ?? "00:00AM";
                      
                      return TaskItem(
                        text: itemText,
                        value: itemValue,
                        time: itemTime,
                        onDismissed: (direction) => PomodoroFunctions.deleteTask(
                          index: index, 
                          currentTab: currentTab, 
                          ref: ref),
                        // onChanged: (value) => PomodoroFunctions.tabShiftFunction(
                        onChanged: (value) => PomodoroFunctions.tabShift(
                          value: value!, 
                          index: index, 
                          currentTab: currentTab, 
                          ref: ref,
                        ),
                      );
                    }),
                      
                  // Add task button for pending tasks
                  if (currentTab == 0)
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            // showNewTaskDialog(context, ref);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return TextDialogue(ref: ref);
                            //   });
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                // return NewTaskDialogue(ref: ref);
                                return TextDialogueCupertino(ref: ref);
                              });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pendingTasks.isEmpty
                                    ? "+ Add a task to get started"
                                    : "+ Add a new task",
                                style: ThemeConstants.boldText(context),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
