//import 'package:fitvoice/models/food_items_model.dart';
//import 'package:fitvoice/models/food_items_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitvoice/screens/meal_review_screen.dart';
import 'package:fitvoice/models/meal_report_model.dart';

class MealReportCard extends StatelessWidget {
  const MealReportCard({
    super.key,
    required this.mealReport,
    required this.authToken,
  });
  final String? authToken;
  final MealReportModel mealReport;

  ListTile setTiles(MealReportModel meal) {
    DateTime mealTime = meal.mealRecordedAt;
    var weekDay = DateFormat('EEEE');
    var formatter = DateFormat('d MMMM, y');

    return ListTile(
      title: Text(
        'Comida del dia: ${weekDay.format(mealTime)}',
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontFamily: 'BrandonGrotesque'),
      ),
      subtitle: Text(
        'Fecha: ${formatter.format(mealTime)}',
        style: const TextStyle(
            fontWeight: FontWeight.w300, fontFamily: 'BrandonGrotesque'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealReviewScreen(
                  mealReport: mealReport,
                  authToken: authToken,
                ),
              ),
            );
          },
          child: setTiles(mealReport),
        ),
      ),
    );
  }
}
