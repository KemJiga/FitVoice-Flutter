import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
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
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr?fetchFoodReports=true');

    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      for (var report in jsonResponse) {
        print(report);
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

        if (meal.pending) {
          _pendingReports.add(MealReportCard(mealReport: meal));
        } else {
          _readedReports.add(MealReportCard(mealReport: meal));
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
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
            child: ListOfMealReports(
              newMealReports: _pendingReports,
              readedReports: _readedReports,
              changePage: widget.changePage,
            ),
          );
        }
      },
    );
  }
}
