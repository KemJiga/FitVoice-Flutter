import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
import 'package:fitvoice/models/unit_transformation_info.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/screens/suggested_food_screen.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MealInfoCard extends StatefulWidget {
  const MealInfoCard({
    super.key,
    required this.mrrId,
    required this.frrId,
    required this.authToken,
    required this.onRefresh,
  });

  final String mrrId;
  final String frrId;
  final String? authToken;
  final void Function() onRefresh;

  @override
  _MealInfoCardState createState() => _MealInfoCardState();
}

class _MealInfoCardState extends State<MealInfoCard> {
  late UserReportModel userReport;
  late FoodItemsModel foodReports;

  Future<void> getFoodReports(String mrrId, String frrId) async {
    var baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/frr/$frrId?mrrId=$mrrId');

    var res = await http.get(
      URL,
      headers: {
        'Authorization': 'Bearer ${widget.authToken}',
      },
    );

    if (res.statusCode == 200) {
      var foodReport = jsonDecode(res.body);
      var userReportAux = foodReport['userReport'];
      String foodName = userReportAux['foodName'];
      List<String> foodDescription = [];
      for (var description in userReportAux['description']) {
        foodDescription.add(description);
      }
      double foodAmount = userReportAux['amount'] is int
          ? (userReportAux['amount'] as int).toDouble()
          : userReportAux['amount'];
      String foodUnit = userReportAux['unit'];

      userReport = UserReportModel(
        foodName: foodName,
        description: foodDescription,
        amount: foodAmount,
        unit: foodUnit,
      );

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
        bool unitWasTransformed =
            foundFoodItem['unitWasTransformed'].toString().toLowerCase() ==
                'true';
        bool amountByUser =
            foundFoodItem['amountByUser'].toString().toLowerCase() == 'true';
        bool servingSizeWasUsed =
            foundFoodItem['servingSizeWasUsed'].toString().toLowerCase() ==
                'true';
        UnitTransformationInfo? unitTransformation;
        if (foundFoodItem['unitTransformationInfo'] != null) {
          var unitTransformationInfo = foundFoodItem['unitTransformationInfo'];
          String originalUnit = unitTransformationInfo['originalUnit'];
          String finalUnit = unitTransformationInfo['finalUnit'];
          double transformationFactor =
              unitTransformationInfo['transformationFactor'] is int
                  ? (unitTransformationInfo['transformationFactor'] as int)
                      .toDouble()
                  : unitTransformationInfo['transformationFactor'];

          UnitTransformationInfo unitTransformationInfoModel =
              UnitTransformationInfo(
            originalUnit: originalUnit,
            finalUnit: finalUnit,
            transformationFactor: transformationFactor,
          );
          unitTransformation = unitTransformationInfoModel;
        }

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
        double fat =
            food['fat'] is int ? (food['fat'] as int).toDouble() : food['fat'];
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
          servingSizeWasUsed: servingSizeWasUsed,
          unitTransformationInfo: unitTransformation,
        );
      }

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
            suggestion['unitWasTransformed'].toString().toLowerCase() == 'true';
        bool suggestionAmountByUser =
            suggestion['amountByUser'].toString().toLowerCase() == 'true';
        bool suggestionServingSizeWasUsed =
            suggestion['servingSizeWasUsed'].toString().toLowerCase() == 'true';
        UnitTransformationInfo? suggestionUnitTransformation;
        if (suggestion['unitTransformationInfo'] != null) {
          var suggestionUnitTransformationInfo =
              suggestion['unitTransformationInfo'];
          String originalUnit =
              suggestionUnitTransformationInfo['originalUnit'];
          String finalUnit = suggestionUnitTransformationInfo['finalUnit'];
          double transformationFactor =
              suggestionUnitTransformationInfo['transformationFactor'] is int
                  ? (suggestionUnitTransformationInfo['transformationFactor']
                          as int)
                      .toDouble()
                  : suggestionUnitTransformationInfo['transformationFactor'];

          UnitTransformationInfo suggestionUnitTransformationInfoModel =
              UnitTransformationInfo(
            originalUnit: originalUnit,
            finalUnit: finalUnit,
            transformationFactor: transformationFactor,
          );
          suggestionUnitTransformation = suggestionUnitTransformationInfoModel;
        }

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
        double suggestionPortionSize = suggestionFood['portionSize'] is int
            ? (suggestionFood['portionSize'] as int).toDouble()
            : suggestionFood['portionSize'];
        String suggestionPortionSizeUnit = suggestionFood['portionSizeUnit'];
        double suggestionServingSize = suggestionFood['servingSize'] is int
            ? (suggestionFood['servingSize'] as int).toDouble()
            : suggestionFood['servingSize'];
        String suggestionServingSizeUnit = suggestionFood['servingSizeUnit'];
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
        double suggestionCarbohydrates = suggestionFood['carbohydrates'] is int
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
          servingSizeWasUsed: suggestionServingSizeWasUsed,
          unitTransformationInfo: suggestionUnitTransformation,
        );

        suggestionsList.add(suggestionFoodItemModel);
      }

      foodReports = FoodItemsModel(
        foodFoundItem: hasItems ? foundFoodItemModel : null,
        suggestions: suggestionsList,
      );
    } else {
      throw Exception('Failed to load food reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFoodReports(widget.mrrId, widget.frrId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(
                  color: Estilos.color1,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 10,
            width: double.infinity,
          );
        } else {
          String foodName = userReport.foodName;
          foodName = foodName[0].toUpperCase() + foodName.substring(1);
          String foodDescription = userReport.getDescription();
          String subtitle = foodDescription.isNotEmpty
              ? '$foodName - $foodDescription'
              : foodName;
          return Card(
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 30,
                  color: Estilos.color1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alimento reportado:',
                          style: Estilos.textStyle1(16, Estilos.color5, 'bold'),
                        ),
                        const SizedBox(
                          width: double.infinity,
                        ),
                        Text(
                          '\t\t$subtitle',
                          style:
                              Estilos.textStyle1(16, Estilos.color5, 'normal'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 36,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SuggestedFoodScreen(
                                        mrrId: widget.mrrId,
                                        frrId: widget.frrId,
                                        userReport: userReport,
                                        foodItems: foodReports,
                                        authToken: widget.authToken,
                                      ),
                                    ),
                                  ).then((value) {
                                    widget.onRefresh();
                                    if (value != null) {
                                      setState(() {
                                        // getFoodReports(
                                        //     widget.mrrId, widget.frrId);
                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  'Ver detalles \u2192',
                                  style: Estilos.textStyle1(
                                      14, Estilos.color1, 'normal'),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
