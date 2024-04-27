import 'package:fitvoice/widgets/meal_report.dart';
import 'package:flutter/material.dart';

//import 'package:fitvoice/dummydata.dart';
import 'package:fitvoice/widgets/listof_mr.dart';

class ReportsScreen extends StatefulWidget {
  final void Function(int) changePage;
  final List<MealReportCard> pendingReports;
  final List<MealReportCard> readedReports;

  const ReportsScreen(
      {super.key,
      required this.changePage,
      required this.pendingReports,
      required this.readedReports});

  //TODO: los datos seran pasados como parametros de clase desde la tabscreen
  // getPendingReports() {
  //   List<MealReportCard> pedingR =
  //       dummyData.map((e) => MealReportCard(mealReport: e)).toList();
  //   return pedingR;
  // }

  // getReadedReports() {
  //   List<MealReportCard> readedR = [];
  //   return readedR;
  // }

  @override
  State<StatefulWidget> createState() {
    return _ReportScreenState();
  }
}

class _ReportScreenState extends State<ReportsScreen> {
  // late List<MealReportCard> _pendingReports;
  // late List<MealReportCard> _readedReports;
  // void getDisplayableReports() {
  //   setState(() {
  //     _pendingReports = widget.getPendingReports();
  //     _readedReports = widget.getReadedReports();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getDisplayableReports();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      child: ListOfMealReports(
        // se supone que la funcion getReports retorna una lista de informacion util para hacer los MRR
        // eso es lo que se le envia a la lista de MRR, no el objeto MealReportCard
        newMealReports: widget.pendingReports,
        readedReports: widget.readedReports,
        changePage: widget.changePage,
      ),
    );
  }
}
