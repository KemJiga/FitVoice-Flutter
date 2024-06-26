import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/meal_report.dart';

class TReportList extends StatelessWidget {
  final List<MealReportCard> reports;

  const TReportList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return reports[index];
          },
          itemCount: reports.length,
        ),
      ),
    );
  }
}
