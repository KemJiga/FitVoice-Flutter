import 'package:fitvoice/dummydata.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/models/user_model.dart';
import 'package:fitvoice/screens/dashboard_screen.dart';
import 'package:fitvoice/screens/database_screen.dart';
import 'package:fitvoice/screens/meal_reports_screen.dart';
import 'package:fitvoice/screens/profile_screen.dart';
import 'package:fitvoice/screens/record_screen.dart';
import 'package:fitvoice/widgets/meal_report.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  String getDate() {
    final String locale = Intl.getCurrentLocale();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d, EEEE', locale).format(now);
    return formattedDate;
  }

  List<MealReportModel> fetchReports() {
    return dummyData;
  }

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 2;
  UserModel user = dummyUser;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const RecordScreen();

    var date = widget.getDate();
    var data = widget.fetchReports();
    var dataCards = data.map((e) => MealReportCard(mealReport: e)).toList();

    var activePagename = "Grabar";
    switch (_selectedPageIndex) {
      case 0:
        activePage = DashboardScreen(
          reports: data,
        );
        activePagename = "Principal";
        break;
      case 1:
        activePage = ReportsScreen(
            changePage: _selectPage,
            pendingReports: dataCards,
            readedReports: []);
        activePagename = "Reportes";
        break;
      case 2:
        activePage = const RecordScreen();
        activePagename = "Grabar";
        break;
      case 3:
        activePage = const DatabaseScreen();
        activePagename = "Datos";
        break;
      case 4:
        activePage = ProfileScreen(
          user: user,
        );
        activePagename = "Perfil";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        title: Center(
          child: Column(
            children: [
              Text(
                activePagename,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_outlined),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none_outlined),
            label: 'Grabar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Datos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
