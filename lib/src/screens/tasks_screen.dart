import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String _searchQuery = "";
  String _filterStatus = "All";
  bool _sortByDueDate = false;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = ref.watch(TaskNotifier as ProviderListenable);
    final tasks = tasksProvider.getFilteredAndSortedTasks(
      query: _searchQuery,
      filterStatus: _filterStatus,
      sortByDueDate: _sortByDueDate,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top panel
          Container(
            width: screenWidth,
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.02),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E6521), Color(0xFF4CAF50)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  "Tasks",
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Search, Filter, and Sort
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.02,
              bottom: screenHeight * 0.02,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Search tasks...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: _filterStatus,
                  onChanged: (value) => setState(() => _filterStatus = value!),
                  items: ["All", "Pending", "Completed", "Overdue"]
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  icon: const Icon(Icons.filter_list),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(
                    _sortByDueDate ? Icons.sort_by_alpha : Icons.calendar_today,
                  ),
                  onPressed: () =>
                      setState(() => _sortByDueDate = !_sortByDueDate),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 14.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 3,
                  color: task.isCompleted
                      ? Colors.green
                          .shade200 // Green background for completed tasks
                      : Colors.white,
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Rounded',
                      ),
                    ),
                    subtitle: Text(
                      'Due: ${task.dueDate.toString().split(' ')[0]}',
                      style: TextStyle(
                        color: task.isCompleted
                            ? Colors.white // White text for completed tasks
                            : Colors.grey,
                        fontFamily: 'SF Pro Rounded',
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        task.isCompleted
                            ? IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  tasksProvider.markAsPending(task.id);
                                  setState(() {});
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () {
                                  tasksProvider.completeTask(task.id);
                                  setState(() {});
                                },
                              ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            tasksProvider.removeTask(task.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show task details
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            task.title,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Rounded',
                            ),
                            textAlign: TextAlign.center, // Center the title
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Due: ${task.dueDate.toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                ),
                              ),
                              Text(
                                'Status: ${task.isCompleted ? 'Completed' : 'Pending'}',
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            // Row to align Edit and Close buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Align buttons to the edges
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    // Navigate to TaskDetailScreen and pass the task data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TaskDetailScreen(task: task),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
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

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController detailsController;
  late TextEditingController dueDateController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current task data
    titleController = TextEditingController(text: widget.task.title);
    detailsController =
        TextEditingController(text: widget.task.description ?? "");
    _dueDate = widget.task.dueDate; // Set initial due date
  }

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void saveTask() {
    // Placeholder for saving task data
    print(
        'Task saved: ${titleController.text}, ${detailsController.text}, ${_dueDate?.toIso8601String()}');
    Navigator.pop(context); // Go back after saving
  }

  void cancelEditing() {
    Navigator.pop(context); // Go back without saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003A86),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontFamily: 'SF Pro Rounded',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editable Title Field
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                ),
                style:
                    const TextStyle(fontFamily: 'SF Pro Rounded', fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Editable Due Date Field with GestureDetector and DatePicker
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null && selectedDate != _dueDate) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  child: Text(
                    _dueDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(_dueDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Editable Task Details Field
              const Text(
                "Details:",
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  hintText: 'Enter task details',
                ),
                maxLines: 3,
                style:
                    const TextStyle(fontFamily: 'SF Pro Rounded', fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: cancelEditing,
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveTask,
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003A86),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
