import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
import 'package:fitvoice/models/meal_model.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitvoice/widgets/listof_mr.dart';

class ReportsScreen extends StatefulWidget {
  final void Function(int) changePage;
  final String? authToken;

  const ReportsScreen(
      {super.key, required this.changePage, required this.authToken});

  @override
  State<StatefulWidget> createState() {
    return _ReportScreenState();
  }
}

class _ReportScreenState extends State<ReportsScreen> {
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
  final List<MealReportCard> _pendingReports = [];
  final List<MealReportCard> _readedReports = [];

  Future<List<List<MealReportCard>>> getDisplayableReports() async {
    _pendingReports.clear();
    _readedReports.clear();

    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr?fetchFoodReports=true');

    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      for (var report in jsonResponse) {
        String mealId = report['id'];
        String appUserId = report['appUserId'];
        String audioId = report['audioId'];
        String rawTranscript = report['rawTranscript'];

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
        DateTime mealRecordedAt = DateTime.parse(report['mealRecordedAt']);
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

        if (meal.pending) {
          _pendingReports.add(MealReportCard(
            mealReport: meal,
            authToken: widget.authToken,
          ));
        } else {
          _readedReports.add(MealReportCard(
            mealReport: meal,
            authToken: widget.authToken,
          ));
        }
      }

      List<List<MealReportCard>> mealReportCards = [];
      mealReportCards.add(_pendingReports);
      mealReportCards.add(_readedReports);
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
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error building: ${snapshot.error}'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
            child: ListOfMealReports(
              newMealReports: _pendingReports,
              readedReports: _readedReports,
              changePage: widget.changePage,
              callback: () {
                setState(() {});
              },
            ),
          );
        }
      },
    );
  }
}
