import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:fitvoice/widgets/today_reports.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.authToken});

  final String? authToken;

  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';

  Future<List<MealReportCard>> getReports() async {
    List<MealReportCard> mealReportCards = [];
    // var queryParams = {
    //   'fetchFoodReports': true,
    // };
    // var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr')
    //     .replace(queryParameters: queryParams);
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr');
    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      for (var report in jsonResponse) {
        var mealId = report['id'];
        var appUserId = report['appUserId'];
        var audioId = report['audioId'];
        var rawTranscript = report['rawTranscript'];

        // Informacion entendida por el backend
        var foodReports = report['foodReports'];
        //var foundFoodId = foodReports['id'];

        var userReport = foodReports['userReport'];
        var foodName = userReport['foodName'];
        var foodDescription = userReport['description'];
        var foodAmount = userReport['amount'];
        var foodUnit = userReport['unit'];

        UserReportModel userReportModel = UserReportModel(
          foodName: foodName,
          description: foodDescription,
          amount: foodAmount,
          unit: foodUnit,
        );

        // Informacion de la comida mas cercana a lo reportado

        var systemResult = foodReports['systemResult'];

        var foundFoodItem = systemResult['foundFoodItem'];
        var foodItemId = foundFoodItem['id'];
        var score = foundFoodItem['score'];
        var amount = foundFoodItem['amount'];
        var unitWasTransformed = foundFoodItem['unitWasTransformed'];
        var amountByUser = foundFoodItem['amountByUser'];

        var food = foundFoodItem['food'];
        var foodId = food['id'];
        var foundFoodName = food['foodName'];
        var otherNames = food['otherNames'];
        var foundFoodDescription = food['description'];
        var portionSize = food['portionSize'];
        var portionSizeUnit = food['portionSizeUnit'];
        var servingSize = food['servingSize'];
        var servingSizeUnit = food['servingSizeUnit'];
        var foodSource = food['foodSource'];
        var calories = food['calories'];
        var protein = food['protein'];
        var fat = food['fat'];
        var carbohydrates = food['carbohydrates'];

        FoodModel foundFoodModel = FoodModel(
          id: foodId,
          foodName: foundFoodName,
          otherNames: otherNames,
          description: foundFoodDescription,
          portionSize: portionSize,
          portionSizeUnit: portionSizeUnit,
          servingSize: servingSize,
          servingSizeUnit: servingSizeUnit,
          foodSource: foodSource,
          calories: calories,
          protein: protein,
          fat: fat,
          carbohydrates: carbohydrates,
        );

        FoodReportModel foundFoodItemModel = FoodReportModel(
          id: foodItemId,
          food: foundFoodModel,
          score: score,
          amount: amount,
          unitWasTransformed: unitWasTransformed,
          amountByUser: amountByUser,
        );

        // Informacion de las sugerencias
        var suggestions = systemResult['suggestions'];
        List<FoodReportModel> suggestionsList = [];

        for (var suggestion in suggestions) {
          var suggestionFoodItemId = suggestion['id'];
          var suggestionScore = suggestion['score'];
          var suggestionAmount = suggestion['amount'];
          var suggestionUnitWasTransformed = suggestion['unitWasTransformed'];
          var suggestionAmountByUser = suggestion['amountByUser'];

          var suggestionFood = suggestion['food'];
          var suggestionFoodId = suggestionFood['id'];
          var suggestionFoodName = suggestionFood['foodName'];
          var suggestionOtherNames = suggestionFood['otherNames'];
          var suggestionFoodDescription = suggestionFood['description'];
          var suggestionPortionSize = suggestionFood['portionSize'];
          var suggestionPortionSizeUnit = suggestionFood['portionSizeUnit'];
          var suggestionServingSize = suggestionFood['servingSize'];
          var suggestionServingSizeUnit = suggestionFood['servingSizeUnit'];
          var suggestionFoodSource = suggestionFood['foodSource'];
          var suggestionCalories = suggestionFood['calories'];
          var suggestionProtein = suggestionFood['protein'];
          var suggestionFat = suggestionFood['fat'];
          var suggestionCarbohydrates = suggestionFood['carbohydrates'];

          FoodModel suggestionFoodModel = FoodModel(
            id: suggestionFoodId,
            foodName: suggestionFoodName,
            otherNames: suggestionOtherNames,
            description: suggestionFoodDescription,
            portionSize: suggestionPortionSize,
            portionSizeUnit: suggestionPortionSizeUnit,
            servingSize: suggestionServingSize,
            servingSizeUnit: suggestionServingSizeUnit,
            foodSource: suggestionFoodSource,
            calories: suggestionCalories,
            protein: suggestionProtein,
            fat: suggestionFat,
            carbohydrates: suggestionCarbohydrates,
          );

          FoodReportModel suggestionFoodItemModel = FoodReportModel(
            id: suggestionFoodItemId,
            food: suggestionFoodModel,
            score: suggestionScore,
            amount: suggestionAmount,
            unitWasTransformed: suggestionUnitWasTransformed,
            amountByUser: suggestionAmountByUser,
          );

          suggestionsList.add(suggestionFoodItemModel);
        }

        var dbLookupPreference = foodReports['dbLookupPreference'];
        var mealRecordedAt = foodReports['mealRecordedAt'];
        var pending = foodReports['pending'];

        FoodItemsModel foodItemsModel = FoodItemsModel(
          foodFoundItem: foundFoodItemModel,
          suggestions: suggestionsList,
        );

        MealReportModel meal = MealReportModel(
          userReport: userReportModel,
          id: mealId,
          appUserId: appUserId,
          audioId: audioId,
          rawTranscript: rawTranscript,
          foodReports: foodItemsModel,
          dbLookupPreference: dbLookupPreference,
          mealRecordedAt: mealRecordedAt,
          pending: pending,
        );

        if (meal.mealRecordedAt.isAfter(today)) {
          mealReportCards.add(MealReportCard(mealReport: meal));
        }
      }

      return mealReportCards;
    } else if (res.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load reports');
    }
  }

  List<double> getMealInfo(List<MealReportModel> meals) {
    double protein = 0;
    double fat = 0;
    double carbs = 0;
    double calories = 0;

    for (MealReportModel meal in meals) {
      FoodItemsModel foodItems = meal.foodReports;
      FoodReportModel foodReport = foodItems.foodFoundItem;
      FoodModel food = foodReport.food;

      protein += food.protein;
      fat += food.fat;
      carbs += food.carbohydrates;
      calories += food.calories;
    }

    return [protein, fat, carbs, calories];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Estilos.color1,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var mealCards = snapshot.data as List<MealReportCard>;
          var meals = mealCards.map((e) => e.mealReport).toList();
          var mealsInfo = getMealInfo(meals);
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
                const SizedBox(
                  height: 20,
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
      },
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
