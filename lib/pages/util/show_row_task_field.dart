import 'package:flutter/material.dart';
import 'package:task_management/theme/theme.dart';


//custom row with some widget to show data for show_task.dart file and show data in search file
class RowTaskData extends StatelessWidget {
  final bool isCompleted;
  final IconData iconData;
  final String taskfieldName;
  final String taskData;

  const RowTaskData(
      {super.key,
      required this.iconData,
      required this.taskfieldName,
      required this.taskData,
      required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData),
            smallWidth,
            Text(
              taskfieldName,
              style: TextStyle(
                  decoration: isCompleted ? TextDecoration.lineThrough : null),
            ),
          ],
        ),
        Text(
          taskData,
          style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null),
        ),
      ],
    );
  }
}
