import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final tasks = tasksProvider.tasks;
    final pendingCount = tasks
        .where(
            (task) => !task.isCompleted && task.dueDate.isAfter(DateTime.now()))
        .length;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    final overdueCount = tasks
        .where((task) =>
            !task.isCompleted && task.dueDate.isBefore(DateTime.now()))
        .length;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width top panel with gradient
          Container(
            width: screenWidth,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF262E6E), Color(0xFF4154F1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
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
                SizedBox(height: 7),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Task list title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF262E6E), // New background color
                borderRadius: BorderRadius.circular(20), // Rounded edges
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                "My Tasks",
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color to contrast with background
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Scrollable task cards
          SizedBox(
            height: 300, // Height of the task cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _TaskCard(task: tasks[index]);
              },
            ),
          ),
          // Task Overview
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ],
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
    Key? key,
    required this.title,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, // Fixed width for each card
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Rounded edges
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

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF262E6E),
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
            const SizedBox(height: 20),
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

// Task card Widget
class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        width: 200,
        height: 275,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF262E6E), Color(0xFF4154F1)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
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
