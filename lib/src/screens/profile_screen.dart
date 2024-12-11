import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo[100],
              child: const Icon(Icons.person, size: 50, color: Colors.indigo),
            ),
            const SizedBox(height: 16.0),
            Text('John Doe', style: Theme.of(context).textTheme.titleLarge),
            const Text('john.doe@example.com'),
            const SizedBox(height: 32.0),
            ListTile(
              title: const Text('Tasks Completed This Month'),
              subtitle: const Text('25'),
              leading: const Icon(Icons.task_alt),
            ),
            ListTile(
              title: const Text('My Goals'),
              subtitle: const Text('Complete 50 tasks'),
              leading: const Icon(Icons.flag),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
