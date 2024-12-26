import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static const String apiUrl = 'http://localhost:3000/tasks';

  // Fetch tasks from API or local storage
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getString('tasks');

    if (storedTasks != null) {
      return List<Map<String, dynamic>>.from(json.decode(storedTasks));
    } else {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final tasks = json.decode(response.body);
        prefs.setString('tasks', json.encode(tasks));
        return List<Map<String, dynamic>>.from(tasks);
      } else {
        throw Exception('Failed to load tasks');
      }
    }
  }

  // Add a new task
  Future<void> addTask(Map<String, dynamic> task) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      final storedTasks = prefs.getString('tasks');
      final tasks = storedTasks != null ? List<Map<String, dynamic>>.from(json.decode(storedTasks)) : [];
      tasks.add(json.decode(response.body));
      prefs.setString('tasks', json.encode(tasks));
    } else {
      throw Exception('Failed to add task');
    }
  }

  // Update a task
  Future<void> updateTask(int id, Map<String, dynamic> task) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final storedTasks = prefs.getString('tasks');
      final tasks = storedTasks != null ? List<Map<String, dynamic>>.from(json.decode(storedTasks)) : [];
      final index = tasks.indexWhere((t) => t['id'] == id);
      if (index != -1) {
        tasks[index] = json.decode(response.body);
        prefs.setString('tasks', json.encode(tasks));
      }
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (response.statusCode == 204) {
      final prefs = await SharedPreferences.getInstance();
      final storedTasks = prefs.getString('tasks');
      final tasks = storedTasks != null ? List<Map<String, dynamic>>.from(json.decode(storedTasks)) : [];
      tasks.removeWhere((task) => task['id'] == id);
      prefs.setString('tasks', json.encode(tasks));
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
