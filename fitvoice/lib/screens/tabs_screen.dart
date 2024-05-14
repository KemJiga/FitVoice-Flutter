// import 'package:fitvoice/models/healthdata_model.dart';
// import 'package:fitvoice/models/meal_report_model.dart';
// import 'package:fitvoice/models/user_model.dart';
import 'package:fitvoice/screens/dashboard_screen.dart';
import 'package:fitvoice/screens/database_screen.dart';
import 'package:fitvoice/screens/meal_reports_screen.dart';
import 'package:fitvoice/screens/profile_screen.dart';
import 'package:fitvoice/screens/record_screen.dart';
import 'package:fitvoice/utils/styles.dart';
//import 'package:fitvoice/widgets/meal_report.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.authToken});
  final String? authToken;

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 2;

  String getDate() {
    final String locale = Intl.getCurrentLocale();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d, EEEE', locale).format(now);
    return formattedDate;
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = RecordScreen(
      authToken: widget.authToken!,
    );
    var date = getDate();
    //var data = fetchReports();
    //var dataCards = data.map((e) => MealReportCard(mealReport: e)).toList();

    var activePagename = "Grabar";
    //TODO: entregar el authtoken y hacer que cada pantalla se encargue de sus datos
    switch (_selectedPageIndex) {
      case 0:
        activePage = DashboardScreen(authToken: widget.authToken!);
        activePagename = "Principal";
        break;
      case 1:
        activePage = ReportsScreen(
          changePage: _selectPage,
          authToken: widget.authToken!,
        );
        activePagename = "Reportes";
        break;
      case 2:
        activePage = RecordScreen(authToken: widget.authToken!);
        activePagename = "Grabar";
        break;
      case 3:
        activePage = const DatabaseScreen();
        activePagename = "Datos";
        break;
      case 4:
        activePage = ProfileScreen(authToken: widget.authToken!);
        activePagename = "Perfil";
        break;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          title: Center(
            child: Column(
              children: [
                Text(
                  activePagename,
                  style: Estilos.textStyle1(14, Estilos.color5, 'bold'),
                ),
                Text(
                  date,
                  style: Estilos.textStyle1(12, Estilos.color5, 'bold'),
                ),
              ],
            ),
          ),
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontFamily: 'BrandonGrotesque'),
          selectedItemColor: Estilos.color1,
          unselectedItemColor: Estilos.color5,
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
      ),
    );
  }
}
