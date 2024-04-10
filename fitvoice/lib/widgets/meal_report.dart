import 'package:flutter/material.dart';

class MealReportCard extends StatelessWidget {
  const MealReportCard({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text('Meal Report $id'),
      ),
    );
  }
}
