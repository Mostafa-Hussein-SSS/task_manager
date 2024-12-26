import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';


// Home Screen Main Widget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.watch(taskProvider);
    final tasks = taskNotifier.tasks;
    final pendingCount = tasks
        .where((task) => !task.isCompleted && task.dueDate.isAfter(DateTime.now()))
        .length;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    final overdueCount = tasks
        .where((task) => !task.isCompleted && task.dueDate.isBefore(DateTime.now()))
        .length;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width top panel with gradient
          Container(
            width: screenWidth,
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.02),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003A86), Color(0xFF046EE5)],
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
                  "Dashboard",
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
          SizedBox(height: screenHeight * 0.03),

          // Task list title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Container(
              alignment: Alignment.center,
              width: screenWidth * 0.48,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: const Color(0xFF046EE5),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015),
              child: const Text(
                textAlign: TextAlign.center,
                "Most Recent Tasks",
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Scrollable task cards
          SizedBox(
            height: screenHeight * 0.3,
            width: screenWidth,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _TaskCard(task: tasks[index]);
              },
            ),
          ),

          // Horizontal line as a break
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.057,
              horizontal: screenWidth * 0.15,
            ),
            child: const Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),

          // Task Overview
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatsCard(
                  title: 'Pending',
                  count: pendingCount,
                  color: Colors.orange[300]!,
                ),
                _StatsCard(
                  title: 'Completed',
                  count: completedCount,
                  color: Colors.green[300]!,
                ),
                _StatsCard(
                  title: 'Overdue',
                  count: overdueCount,
                  color: Colors.red[300]!,
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return const TaskAddModal();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF046EE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  fixedSize: Size(screenWidth, screenHeight * 0.08),
                  elevation: 6, // Shadow for the button
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                child: const Text(
                  "Add Task",
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: screenHeight * 0.02))
        ],
      ),
    );
  }
}

// Task card Widget
class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        width: screenWidth * 0.48,
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          color: const Color(0xFF003A86),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "${task.dueDate.day.toString().padLeft(2, '0')} "
                      "${DateFormat('MMMM').format(task.dueDate)} "
                      "${task.dueDate.year}",
                  style: const TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              Center(
                child: Text(
                  task.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Task overview card Widget
class _StatsCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontFamily: 'SF Pro Rounded',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SF Pro Rounded',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// Task Details Screen Widget
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Due Date: ${task.dueDate.toString().split(' ')[0]}",
              style: const TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Details:",
              style: TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description ?? "No details available.",
              style: const TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Task Add Widget
class TaskAddModal extends ConsumerStatefulWidget {
  const TaskAddModal({super.key});

  @override
  ConsumerState<TaskAddModal> createState() => _TaskAddModalState();
}

class _TaskAddModalState extends ConsumerState<TaskAddModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    final taskNotifier = ref.read(taskProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Task",
            style: TextStyle(
              fontFamily: 'SF Pro Rounded',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                  const InputDecoration(labelText: 'Task Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    _dueDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    setState(() {});
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final task = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: _dueDate ?? DateTime.now(),
                        id: '',
                      );

                      taskNotifier.addTask(task);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
