import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextDialogue extends StatefulWidget {
  final WidgetRef ref;

  const TextDialogue({super.key, required this.ref});

  @override
  State<TextDialogue> createState() => _TextDialogueState();
}

class _TextDialogueState extends State<TextDialogue> {
  final TextEditingController taskController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Automatically focus the text field when the dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Clean up the controller and focus node when the widget is removed
    taskController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AlertDialog(
        title: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: taskController,
          focusNode: focusNode, // Attach the focus node
          decoration: InputDecoration(
            hintText: 'Enter task',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              final taskText = taskController.text;
              if (taskText.isNotEmpty) {
                // widget.ref.read(taskListProvider.notifier).addTask({
                //   "text": taskText,
                //   "value": false,
                //   "time": DateTime.now(),
                // });
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
