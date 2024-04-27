//import 'package:fitvoice/models/food_items_model.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/screens/meal_review_screen.dart';

import 'package:fitvoice/models/meal_report_model.dart';

class MealReportCard extends StatelessWidget {
  const MealReportCard({
    super.key,
    required this.mealReport,
  });
  final MealReportModel mealReport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealReviewScreen(mealReport: mealReport),
              ),
            );
          },
          child: ListTile(
            title: Text(
              'Reporte #${mealReport.id}',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            subtitle: Text(mealReport.rawTranscript),
          ),
        ),
      ),
    );
  }
}
