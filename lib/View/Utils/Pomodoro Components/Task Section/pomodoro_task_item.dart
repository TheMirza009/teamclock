import 'package:flutter/material.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class TaskItem extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String time;
  final onDismissed;
  const TaskItem({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
    required this.time, // Pass in a preformatted time from the parent
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {

    final shadowColor = Theme.of(context).brightness == Brightness.light 
    ? Colors.grey.withOpacity(0.3) 
    : Colors.black ;
    return GestureDetector(
    onLongPressStart: (details) => _popupMenu(context, details),
      child: Dismissible(
        key: Key(time),
        direction: DismissDirection.endToStart, // Swipe left to delete
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.transparent,
          child: const Text(
            "Delete",
            style: TextStyle(
              color: Color.fromARGB(255, 185, 42, 42),
            ),
          ),
          // Icon(
          //   Icons.delete,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
        ),
        onDismissed: onDismissed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                // color: Colors.grey.withOpacity(0.3),
                color:  shadowColor,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: value,
                    onChanged: onChanged,
                  ),
              SizedBox(
                width: ThemeConstants.screenWidth*0.55,
                child: Text(
                  text,
                  style: TextStyle(
                    decoration: value ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationThickness: 2.0,
                    fontWeight: FontWeight.w600,
                    fontSize: ThemeConstants.getDynamicFontSize(13),
                  ),
                ),
              ),
                ],
              ),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _popupMenu(BuildContext context, LongPressStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localOffset = renderBox.globalToLocal(details.globalPosition);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        localOffset.dx,
        localOffset.dy,
        0.0,
        0.0,
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        // Perform edit action
        print('Edit selected');
      } else if (value == 'delete') {
        // Perform delete action
        print('Delete selected');
      }
    });
  }

  
}
