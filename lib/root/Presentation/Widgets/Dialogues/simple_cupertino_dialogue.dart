import 'package:flutter/cupertino.dart';

cupertinoSimpleDialogue({
  required BuildContext context,
  required String title,
  required String content,
  required Future<void> Function() onYesPressed,
   }) {
  showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title:  Text(title),
        content:  Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () async {
              await onYesPressed();
              Navigator.of(context).pop();
              }
          ),
        ],
      ),
    );
}