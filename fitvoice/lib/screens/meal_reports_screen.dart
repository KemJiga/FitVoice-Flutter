import 'package:fitvoice/widgets/meal_report.dart';
import 'package:flutter/material.dart';

import 'package:fitvoice/dummydata.dart';
import 'package:fitvoice/widgets/listof_mr.dart';

class ReportsScreen extends StatefulWidget {
  final void Function(int) changePage;

  const ReportsScreen({super.key, required this.changePage});

  //fetches all the reports from the database
  getPendingReports() {
    //fetch pending reports
    List<MealReportCard> pedingR = newMealReports;
    return pedingR;
  }

  getReadedReports() {
    //fetch readed reports
    List<MealReportCard> readedR = readedReports;
    return readedR;
  }

  @override
  State<StatefulWidget> createState() {
    return _ReportScreenState();
  }
}

class _ReportScreenState extends State<ReportsScreen> {
  late List<MealReportCard> _pendingReports;
  late List<MealReportCard> _readedReports;
  void getDisplayableReports() {
    setState(() {
      _pendingReports = widget.getPendingReports();
      _readedReports = widget.getReadedReports();
    });
  }

  @override
  void initState() {
    super.initState();
    //_pendingReports = [];
    //_readedReports = [];
    getDisplayableReports();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      child: ListOfMealReports(
        // se supone que la funcion getReports retorna una lista de informacion util para hacer los MRR
        // eso es lo que se le envia a la lista de MRR, no el objeto MealReportCard
        newMealReports: _pendingReports,
        readedReports: _readedReports,
        changePage: widget.changePage,
      ),
    );
  }
}
