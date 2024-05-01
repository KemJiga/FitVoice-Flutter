import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/utils/meal_info.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:fitvoice/widgets/today_reports.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.reports});

  final List<MealReportModel> reports;
  final MealInfoExtractor mealInfoExtractor =
      MealInfoExtractor(foodReports: []);

  List<MealReportCard> setMealCards(List<MealReportModel> report) {
    List<MealReportModel> reports =
        mealInfoExtractor.getTodayFoodReports(report);
    return reports.map((e) => MealReportCard(mealReport: e)).toList();
  }

  List<FoodItemsModel> getFoodReports() {
    return reports.expand((report) => report.foodReports).toList();
  }

  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    var mealCards = widget.setMealCards(widget.reports);
    var foodReports = widget.getFoodReports();
    var mealsInfo = widget.mealInfoExtractor.getMealInfo(foodReports);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🔥',
                    ),
                    Text(
                      '${mealsInfo[1]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Grasas',
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: MyCirclePainter(),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '♨️',
                        ),
                        Text(
                          '${mealsInfo[3]}',
                          style: const TextStyle(
                            color: Estilos.color1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Kcal',
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 120,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🥣',
                    ),
                    Text(
                      '${mealsInfo[0]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Proteinas',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 120,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🍚',
                ),
                Text(
                  '${mealsInfo[2]}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Carbohidratos',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reportes del día',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Estilos.color1,
                ),
              ),
            ),
          ),
          TReportList(reports: mealCards),
        ],
      ),
    );
  }
}

class MyCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = (size.width - 12) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paintBase = Paint()
      ..color = Estilos.color1
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Paint paintArc1 = Paint()
      //..color = Colors.amber
      ..color = Estilos.color4
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Paint paintArc2 = Paint()
      ..color = Estilos.color2
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paintBase);

    double arcStartAngle = -math.pi / 2; // Start angle for the first arc
    double arcSweepAngle = 2 * math.pi / 3; // Sweep angle for each arc

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      arcStartAngle,
      arcSweepAngle,
      false,
      paintArc1,
    );
    arcStartAngle += (arcSweepAngle);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      arcStartAngle,
      arcSweepAngle,
      false,
      paintArc2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
