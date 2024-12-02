import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/Provider%20Classes/task_manager_class.dart';
import 'package:time_slider/Model/pomodoro_states.dart';

  final FocusNode _focusNode = FocusNode();
class NewTaskDialogue extends StatelessWidget {
  final WidgetRef ref;
  const NewTaskDialogue({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    // Automatically focus the text field when the popup opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        title: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(  // Make the content scrollable
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,  // Limit height of the dialog content
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: taskController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter task',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded borders
                ),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: const Size(double.maxFinite, 50),
              padding: const EdgeInsets.all(0)),
            onPressed: () async {
              String taskText = taskController.text;
              if (taskText.isNotEmpty) {
                // Update the PomodoroStates.pendingTasks state
                // ref.read(taskListProvider.notifier).addTask({
                //   "text": taskText,
                //   "value": false,
                //   "time": DateTime.now(),
                // });
                ref.read(PomodoroStates.pendingTasksProvider.notifier).state.add({
                "text": taskText,
                "value": false, // Set it as a pending task by default
                "time": DateTime.now(),
              });
              await TaskManager(ref).saveTasks();
              }
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
