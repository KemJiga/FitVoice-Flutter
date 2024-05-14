import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
import 'package:fitvoice/models/meal_model.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:fitvoice/widgets/today_reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.authToken});

  final String? authToken;
  int protein = 0;
  int fat = 0;
  int carbs = 0;
  int calories = 0;

  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';

  Future<List<MealReportCard>> getDisplayableReports() async {
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr?fetchFoodReports=true');

    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    double proteinAux = 0;
    double fatAux = 0;
    double carbsAux = 0;
    double caloriesAux = 0;
    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      List<MealReportModel> meals = [];
      for (var report in jsonResponse) {
        String mealId = report['id'];
        String appUserId = report['appUserId'];
        String audioId = report['audioId'];
        String rawTranscript = report['rawTranscript'];
        DateTime mealRecordedAt = DateTime.parse(report['mealRecordedAt']);

        if (mealRecordedAt.isBefore(today)) {
          continue;
        }

        // Informacion entendida por el backend
        var foodReports = report['foodReports'];

        List<MealModel> foodItems = [];
        if (foodReports != null) {
          for (var foodReport in foodReports) {
            // Id del alimento
            String foodReportId = foodReport['id'];

            // Informacion del alimento reportado por el usuario
            var userReport = foodReport['userReport'];
            String foodName = userReport['foodName'];
            List<String> foodDescription = [];
            for (var description in userReport['description']) {
              foodDescription.add(description);
            }
            double foodAmount = userReport['amount'] is int
                ? (userReport['amount'] as int).toDouble()
                : userReport['amount'];
            String foodUnit = userReport['unit'];

            UserReportModel userReportModel = UserReportModel(
              foodName: foodName,
              description: foodDescription,
              amount: foodAmount,
              unit: foodUnit,
            );

            // Informacion de la comida mas cercana a lo reportado

            var systemResult = foodReport['systemResult'];

            var foundFoodItem = systemResult['foundFoodItem'];
            late FoodReportModel foundFoodItemModel;
            var hasItems = foundFoodItem != null;
            if (foundFoodItem != null) {
              String foodItemId = foundFoodItem['id'];
              double score = foundFoodItem['score'] is int
                  ? (foundFoodItem['score'] as int).toDouble()
                  : foundFoodItem['score'];
              double amount = foundFoodItem['amount'] is int
                  ? (foundFoodItem['amount'] as int).toDouble()
                  : foundFoodItem['amount'];
              bool unitWasTransformed = foundFoodItem['unitWasTransformed']
                      .toString()
                      .toLowerCase() ==
                  'true';
              bool amountByUser =
                  foundFoodItem['amountByUser'].toString().toLowerCase() ==
                      'true';

              var food = foundFoodItem['food'];
              String foodId = food['id'];
              String foundFoodName = food['foodName'];
              List<String> otherNames = [];
              for (var otherName in food['otherNames']) {
                otherNames.add(otherName);
              }
              List<String> foundFoodDescription = [];
              for (var description in food['description']) {
                foundFoodDescription.add(description);
              }
              double portionSize = food['portionSize'] is int
                  ? (food['portionSize'] as int).toDouble()
                  : food['portionSize'];
              String portionSizeUnit = food['portionSizeUnit'];
              double servingSize = food['servingSize'] is int
                  ? (food['servingSize'] as int).toDouble()
                  : food['servingSize'];
              String servingSizeUnit = food['servingSizeUnit'];
              String foodSource = food['foodSource'];
              double calories = food['calories'] is int
                  ? (food['calories'] as int).toDouble()
                  : food['calories'];
              double protein = food['protein'] is int
                  ? (food['protein'] as int).toDouble()
                  : food['protein'];
              double fat = food['fat'] is int
                  ? (food['fat'] as int).toDouble()
                  : food['fat'];
              double carbohydrates = food['carbohydrates'] is int
                  ? (food['carbohydrates'] as int).toDouble()
                  : food['carbohydrates'];

              proteinAux += protein;
              fatAux += fat;
              carbsAux += carbohydrates;
              caloriesAux += calories;

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

              // Modelo del alimento encontrado
              foundFoodItemModel = FoodReportModel(
                id: foodItemId,
                food: foundFoodModel,
                score: score,
                amount: amount,
                unitWasTransformed: unitWasTransformed,
                amountByUser: amountByUser,
              );
            }

            // Informacion de las sugerencias
            var suggestions = systemResult['suggestions'];
            List<FoodReportModel> suggestionsList = [];

            for (var suggestion in suggestions) {
              String suggestionFoodItemId = suggestion['id'];
              double suggestionScore = suggestion['score'] is int
                  ? (suggestion['score'] as int).toDouble()
                  : suggestion['score'];
              double suggestionAmount = suggestion['amount'] is int
                  ? (suggestion['amount'] as int).toDouble()
                  : suggestion['amount'];
              bool suggestionUnitWasTransformed =
                  suggestion['unitWasTransformed'].toString().toLowerCase() ==
                      'true';
              bool suggestionAmountByUser =
                  suggestion['amountByUser'].toString().toLowerCase() == 'true';

              var suggestionFood = suggestion['food'];
              String suggestionFoodId = suggestionFood['id'];
              String suggestionFoodName = suggestionFood['foodName'];
              List<String> suggestionOtherNames = [];
              for (var otherName in suggestionFood['otherNames']) {
                suggestionOtherNames.add(otherName);
              }
              List<String> suggestionFoodDescription = [];
              for (var description in suggestionFood['description']) {
                suggestionFoodDescription.add(description);
              }
              double suggestionPortionSize =
                  suggestionFood['portionSize'] is int
                      ? (suggestionFood['portionSize'] as int).toDouble()
                      : suggestionFood['portionSize'];
              String suggestionPortionSizeUnit =
                  suggestionFood['portionSizeUnit'];
              double suggestionServingSize =
                  suggestionFood['servingSize'] is int
                      ? (suggestionFood['servingSize'] as int).toDouble()
                      : suggestionFood['servingSize'];
              String suggestionServingSizeUnit =
                  suggestionFood['servingSizeUnit'];
              String suggestionFoodSource = suggestionFood['foodSource'];
              double suggestionCalories = suggestionFood['calories'] is int
                  ? (suggestionFood['calories'] as int).toDouble()
                  : suggestionFood['calories'];
              double suggestionProtein = suggestionFood['protein'] is int
                  ? (suggestionFood['protein'] as int).toDouble()
                  : suggestionFood['protein'];
              double suggestionFat = suggestionFood['fat'] is int
                  ? (suggestionFood['fat'] as int).toDouble()
                  : suggestionFood['fat'];
              double suggestionCarbohydrates =
                  suggestionFood['carbohydrates'] is int
                      ? (suggestionFood['carbohydrates'] as int).toDouble()
                      : suggestionFood['carbohydrates'];

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

              // Modelo de la sugerencia
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

            FoodItemsModel foodItemsModel = FoodItemsModel(
              foodFoundItem: hasItems ? foundFoodItemModel : null,
              suggestions: suggestionsList,
            );

            MealModel foodItem = MealModel(
              id: foodReportId,
              userReport: userReportModel,
              foodReports: foodItemsModel,
            );

            foodItems.add(foodItem);
          }
        }

        String dbLookupPreference = report['dbLookupPreference'];
        bool pending = report['pending'].toString().toLowerCase() == 'true';

        MealReportModel meal = MealReportModel(
          id: mealId,
          appUserId: appUserId,
          audioId: audioId,
          rawTranscript: rawTranscript,
          foodReports: foodItems,
          dbLookupPreference: dbLookupPreference,
          mealRecordedAt: mealRecordedAt,
          pending: pending,
        );
        meals.add(meal);
      }

      List<MealReportCard> mealReportCards = [];
      for (var meal in meals) {
        MealReportCard mealCard = MealReportCard(
          mealReport: meal,
          authToken: widget.authToken,
        );
        mealReportCards.add(mealCard);
      }

      widget.protein = proteinAux.round();
      widget.fat = fatAux.round();
      widget.carbs = carbsAux.round();
      widget.calories = caloriesAux.round();

      return mealReportCards;
    } else if (res.statusCode == 401) {
      var jsonResponse = jsonDecode(res.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDisplayableReports(),
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
                            '${widget.fat}g',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BrandonGrotesque',
                            ),
                          ),
                          const Text(
                            'Grasas',
                            style: TextStyle(
                              fontFamily: 'BrandonGrotesque',
                            ),
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
                                '${widget.calories}',
                                style: const TextStyle(
                                  color: Estilos.color1,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'BrandonGrotesque',
                                ),
                              ),
                              const Text(
                                'Kcal',
                                style: TextStyle(
                                  fontFamily: 'BrandonGrotesque',
                                ),
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
                            '${widget.protein}g',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BrandonGrotesque',
                            ),
                          ),
                          const Text(
                            'Proteinas',
                            style: TextStyle(
                              fontFamily: 'BrandonGrotesque',
                            ),
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
                        '${widget.carbs}g',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BrandonGrotesque',
                        ),
                      ),
                      const Text(
                        'Carbohidratos',
                        style: TextStyle(
                          fontFamily: 'BrandonGrotesque',
                        ),
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
                        fontFamily: 'BrandonGrotesque',
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
