import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './completed_task_screen.dart';
import './home_screen.dart';
import './add_task_screen.dart';
import './pending_task_screen.dart';
import './important_task_screen.dart';
import './today_task_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 1;
  @override
  void initState() {
    super.initState();
    _pages = [
      {
        "page": const HomeScreen(),
        "title": "All",
      },
      {
        "page": const TodayTaskScreen(),
        "title": "Today's Task",
      },
      {
        "page": const PendingTaskScreen(),
        "title": "Pending",
      },
      {
        "page": const CompletedTaskScreen(),
        "title": "Completed",
      },
      {
        "page": const ImportantTaskScreen(),
        "title": "Important",
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Organiz'Em",
          textScaleFactor: 1,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "All Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: "Due Today",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Pending",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_important),
            label: "Important",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.routeName);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
