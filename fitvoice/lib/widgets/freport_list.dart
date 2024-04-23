import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/food_report.dart';

class FoodReportList extends StatelessWidget {
  final List<FoodReportCard> reports;

  const FoodReportList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return reports[index];
      },
      itemCount: reports.length,
    );
  }
}
