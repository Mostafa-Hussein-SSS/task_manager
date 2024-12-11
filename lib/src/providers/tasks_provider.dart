import 'package:flutter/material.dart';

import '../models/task.dart';

class TasksProvider with ChangeNotifier {
  final List<Task> _tasks = [
    // Sample tasks
    Task(
      id: '1',
      title: 'Complete Project Report',
      description: 'Finish the final project report for submission.',
      dueDate: DateTime.now().add(Duration(days: 3)),
      priority: 'High',
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Team Meeting',
      description: 'Discuss project milestones with the team.',
      dueDate: DateTime.now().add(Duration(days: 1)),
      priority: 'Medium',
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Submit Assignment',
      description: 'Submit the weekly assignment before the deadline.',
      dueDate: DateTime.now().subtract(Duration(days: 2)), // Overdue
      priority: 'Low',
      isCompleted: false,
    ),
  ];

  List<Task> get tasks => [..._tasks];

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Mark a task as completed
  void completeTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = true;
      notifyListeners();
    }
  }

  // Remove a task
  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // Filter tasks by priority
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // Get count of pending tasks
  int get pendingTasksCount {
    return _tasks
        .where(
            (task) => !task.isCompleted && task.dueDate.isAfter(DateTime.now()))
        .length;
  }

  // Get count of completed tasks
  int get completedTasksCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  // Get count of overdue tasks
  int get overdueTasksCount {
    return _tasks
        .where((task) =>
            !task.isCompleted && task.dueDate.isBefore(DateTime.now()))
        .length;
  }
}
