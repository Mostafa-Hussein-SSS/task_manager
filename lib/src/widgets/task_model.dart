// File: widgets/task_model.dart
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function() onMarkComplete;
  final Function() onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onMarkComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Due: ${task.dueDate.toString().split(' ')[0]}',
          style: TextStyle(
            color: task.isCompleted ? Colors.grey : Colors.black54,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(task.priority),
          child: Text(
            task.priority[0], // Display the first letter of the priority
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: onMarkComplete,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
