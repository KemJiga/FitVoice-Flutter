import 'package:fitvoice/screens/dashboard_screen.dart';
import 'package:fitvoice/screens/database_screen.dart';
import 'package:fitvoice/screens/meal_reports_screen.dart';
import 'package:fitvoice/screens/profile_screen.dart';
import 'package:fitvoice/screens/record_screen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  getDate() {
    DateTime now = DateTime.now();
    String formatter = DateFormat('MMMM d, EEEE').format(now);
    return formatter;
  }

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const RecordScreen(); // cambiar a la pagina default

    var date = widget.getDate();

    var activePagename = "Record";
    switch (_selectedPageIndex) {
      case 0:
        activePage = const DashboardScreen();
        activePagename = "Dashboard";
        break;
      case 1:
        activePage = const ReportsScreen();
        activePagename = "Reports";
        break;
      case 2:
        activePage = const RecordScreen();
        activePagename = "Record";
        break;
      case 3:
        activePage = const DatabaseScreen();
        activePagename = "Database";
        break;
      case 4:
        activePage = const ProfileScreen();
        activePagename = "Profile";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(activePagename),
              Text(
                date,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none_outlined),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Database',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
