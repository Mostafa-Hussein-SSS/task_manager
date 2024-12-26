import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import 'package:flutter/foundation.dart';

// Use ChangeNotifier to manage the task list
class TaskNotifier extends ChangeNotifier {
  List<Task> _tasks = [
    Task(id: '1', title: 'Task 1', dueDate: DateTime.now().add(const Duration(days: 1)), isCompleted: false, description: 'testing'),
    Task(id: '2', title: 'Task 2', dueDate: DateTime.now().add(const Duration(days: 2)), isCompleted: false, description: 'testing'),
  ];

  // Getter for tasks
  List<Task> get tasks => _tasks;

  // Add a new task
  void addTask(Task task) {
    _tasks = [..._tasks, task]; // Append the new task to the list
    notifyListeners(); // Notify listeners of state change
    print('Task added: ${task.title}');
  }

  // Mark a task as completed or incomplete
  void toggleCompletion(String id) {
    _tasks = _tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    notifyListeners(); // Notify listeners of state change
  }

  // Remove a task by ID
  void removeTask(String id) {
    _tasks = _tasks.where((task) => task.id != id).toList();
    notifyListeners(); // Notify listeners of state change
  }

  // Get filtered and sorted tasks
  List<Task> getFilteredAndSortedTasks({
    required String query,
    required String filterStatus,
    required bool sortByDueDate,
  }) {
    // Filter tasks based on query and status
    List<Task> filteredTasks = _tasks.where((task) {
      bool matchesQuery = task.title.toLowerCase().contains(query.toLowerCase());
      bool matchesStatus = filterStatus == 'All' ||
          (filterStatus == 'Pending' && !task.isCompleted) ||
          (filterStatus == 'Completed' && task.isCompleted) ||
          (filterStatus == 'Overdue' &&
              task.dueDate.isBefore(DateTime.now()) &&
              !task.isCompleted);
      return matchesQuery && matchesStatus;
    }).toList();

    // Sort tasks by due date if requested
    if (sortByDueDate) {
      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }

    // Ensure completed tasks are at the end
    filteredTasks.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;
      return 0;
    });

    return filteredTasks;
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

// Define a provider using ChangeNotifierProvider to expose TaskNotifier
final taskProvider = ChangeNotifierProvider<TaskNotifier>(
      (ref) => TaskNotifier(),
);
