//import 'package:fitvoice/models/food_items_model.dart';
//import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/utils/date_translator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitvoice/screens/meal_review_screen.dart';
import 'package:fitvoice/models/meal_report_model.dart';

class MealReportCard extends StatelessWidget {
  const MealReportCard({
    super.key,
    required this.mealReport,
    required this.authToken,
    required this.callout,
  });

  final void Function() callout;
  final String? authToken;
  final MealReportModel mealReport;

  ListTile setTiles(MealReportModel meal) {
    DateTime mealTime = meal.mealRecordedAt;
    mealTime = mealTime.toLocal();
    var weekDay = DateFormat('EEEE');
    var day = DateFormat('d');
    var month = DateFormat('MMMM');
    var year = DateFormat('y');
    var timeFormatter = DateFormat('hh:mm a');

    String mealDay = day.format(mealTime);
    String mealMonth = DateTranslator().translateMonth(month.format(mealTime));
    String mealYear = year.format(mealTime);
    String mealWeekDay =
        DateTranslator().translateWeekDay(weekDay.format(mealTime));
    String mealTimeFormatted = timeFormatter.format(mealTime);

    return ListTile(
      title: Text(
        'Comida del dia: $mealWeekDay',
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontFamily: 'BrandonGrotesque'),
      ),
      subtitle: Text(
        'Fecha: $mealDay de $mealMonth, $mealYear - $mealTimeFormatted',
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
            ).then((value) {
              callout();
            });
          },
          child: setTiles(mealReport),
        ),
      ),
    );
  }
}
