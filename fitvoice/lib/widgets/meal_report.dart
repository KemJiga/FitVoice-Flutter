import 'package:fitvoice/models/food_items_model.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/screens/meal_review_screen.dart';

import 'package:fitvoice/models/meal_report_model.dart';

class MealReportCard extends StatelessWidget {
  const MealReportCard(
      {super.key,
      required this.id,
      required this.appUserId,
      required this.audioId,
      required this.rawTranscript,
      required this.foodReports,
      required this.dbLookupPreference,
      required this.mealRecordedAt,
      required this.pending,
      required this.reviewed});

  final String id;
  final String appUserId;
  final String audioId;
  final String rawTranscript;
  final List<FoodItemsModel> foodReports;
  final String dbLookupPreference;
  final DateTime mealRecordedAt;
  final bool pending;
  final bool reviewed;

  MealReportModel get mealReport {
    return MealReportModel(
      id: id,
      appUserId: appUserId,
      audioId: audioId,
      rawTranscript: rawTranscript,
      foodReports: foodReports,
      dbLookupPreference: dbLookupPreference,
      mealRecordedAt: mealRecordedAt,
      pending: pending,
      reviewed: reviewed,
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
                builder: (context) => MealReviewScreen(mealReport: mealReport),
              ),
            );
          },
          child: ListTile(
            title: Text(
              'Reporte #$id',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            subtitle: Text(rawTranscript),
          ),
        ),
      ),
    );
  }
}
