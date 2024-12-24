// lib/providers/tasks_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';

// Use StateNotifier to manage the task list
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  // Add a new task
  void addTask(Task task) {
    state = [...state, task]; // Update state with new task
  }

  // Mark a task as completed or incomplete
  void toggleCompletion(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
  }

  // Remove a task by ID
  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  // Get filtered and sorted tasks
  List<Task> getFilteredAndSortedTasks({
    required String query,
    required String filterStatus,
    required bool sortByDueDate,
  }) {
    List<Task> filteredTasks = state.where((task) {
      bool matchesQuery =
          task.title.toLowerCase().contains(query.toLowerCase());
      bool matchesStatus = filterStatus == 'All' ||
          (filterStatus == 'Pending' && !task.isCompleted) ||
          (filterStatus == 'Completed' && task.isCompleted) ||
          (filterStatus == 'Overdue' &&
              task.dueDate.isBefore(DateTime.now()) &&
              !task.isCompleted);
      return matchesQuery && matchesStatus;
    }).toList();

    // Sort by due date if requested
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
    return state
        .where(
            (task) => !task.isCompleted && task.dueDate.isAfter(DateTime.now()))
        .length;
  }

  // Get count of completed tasks
  int get completedTasksCount {
    return state.where((task) => task.isCompleted).length;
  }

  // Get count of overdue tasks
  int get overdueTasksCount {
    return state
        .where((task) =>
            !task.isCompleted && task.dueDate.isBefore(DateTime.now()))
        .length;
  }
}

// Define a provider using StateNotifierProvider to expose TaskNotifier
final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
