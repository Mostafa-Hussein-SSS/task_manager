// File: models/task.dart
class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority; // High, Medium, or Low
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  // Factory method to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'] ?? 'Medium',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Convert Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
