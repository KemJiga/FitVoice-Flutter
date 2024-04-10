import 'package:fitvoice/widgets/meal_report.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  getReports() {}

  @override
  Widget build(BuildContext context) {
    //var date = getDate();
    return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: List.generate(
          10,
          (index) => MealReportCard(id: index.toString()),
        ));
  }
}
