import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/root/Presentation/Modules/Screens/Pomodoro/viewmodel/pomodoro_functions.dart';

class TextDialogueCupertino extends StatelessWidget {
  final WidgetRef ref;

  const TextDialogueCupertino({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    // Automatically focus the text field when the popup opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    return CupertinoAlertDialog(
      title: const Text(
        'New Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              focusNode: focusNode,
              controller: taskController,
              placeholder: 'Enter task',
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: CupertinoColors.systemGrey6,
              ),
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context), // Dynamic text color based on the theme
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () async {
            final taskText = taskController.text.trim();
            if (taskText.isNotEmpty) PomodoroFunctions.addTask(ref: ref, taskText: taskText);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
