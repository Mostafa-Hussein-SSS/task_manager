import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final tasks = tasksProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Due: ${task.dueDate.toString().split(' ')[0]}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: task.isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked,
                            color: Colors.red),
                    onTap: () {
                      // Show task details
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(task.title),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Priority: ${task.priority}'),
                              Text(
                                  'Due: ${task.dueDate.toString().split(' ')[0]}'),
                              Text(
                                  'Status: ${task.isCompleted ? 'Completed' : 'Pending'}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
