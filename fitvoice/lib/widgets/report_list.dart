import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/meal_report.dart';

class ReportList extends StatelessWidget {
  final List<MealReportCard> reports;

  const ReportList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return reports[index];
        },
        itemCount: reports.length,
      ),
    );
  }
}
