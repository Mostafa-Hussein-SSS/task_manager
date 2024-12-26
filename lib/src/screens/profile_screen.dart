import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            width: screenWidth,
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.02),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0288D1), Color(0xFF03A9F4)],
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
                  "Profile",
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
          const SizedBox(height: 30),
          // Profile Image and Info
          const Center(
            child: Icon(Icons.person, size: 100, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          const Center(
              child: Text(
            'John Doe',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          )),
          const Center(
              child: Text(
            'john.doe@example.com',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
          const SizedBox(height: 100),
          // Profile Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Task and Goal Stats
                Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0288D1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const ListTile(
                    title: Text(
                      'Tasks Completed This Month',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '25',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF Pro Rounded',
                      ),
                    ),
                    leading: Icon(Icons.task_alt, color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF03A9F4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const ListTile(
                    title: Text(
                      'My Goals',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Complete 50 tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF Pro Rounded',
                      ),
                    ),
                    leading: Icon(Icons.flag, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement logout functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  fixedSize:
                      Size(screenWidth * 0.85, 50), // 85% of screen width
                ),
                child: const Text('Log Out'),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
