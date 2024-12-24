import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './src/screens/home_screen.dart';
import './src/screens/profile_screen.dart';
import './src/screens/tasks_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    TasksScreen(),
    ProfileScreen(),
  ];

  static const List<Color> _colors = [
    Color(0xFF003A86),
    Color(0xFF046EE5),
    Color(0xFF1E6521),
    Color(0xFF4CAF50),
    Color(0xFF262E6E),
    Color(0xFF4154F1),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.00,
            bottom: screenHeight * 0.007),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _colors[(_selectedIndex * 2)],
              _colors[(_selectedIndex * 2) + 1]
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.normal,
            fontSize: screenWidth * 0.035,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/icons/home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/icons/task.png')),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/icons/profile.png')),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
