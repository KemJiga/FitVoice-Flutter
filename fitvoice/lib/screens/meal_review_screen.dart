import 'package:fitvoice/screens/suggested_food_screen.dart';
import 'package:fitvoice/utils/meal_info.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/food_report.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/widgets/listof_fr.dart';

// ignore: must_be_immutable
class MealReviewScreen extends StatelessWidget {
  final MealReportModel mealReport;
  late int protein;
  late int fat;
  late int carbs;
  late int calories;

  MealReviewScreen({super.key, required this.mealReport}) {
    final mealInfoExtractor =
        MealInfoExtractor(foodReports: mealReport.foodReports);
    final mealInfo = mealInfoExtractor.getMealInfo(null);
    protein = mealInfo[0];
    fat = mealInfo[1];
    carbs = mealInfo[2];
    calories = mealInfo[3];
  }

  bool areSuggestions() {
    return !mealReport.foodReports
        .any((element) => element.suggestions.isNotEmpty);
  }

  getCards() {
    return mealReport.foodReports.map((foodReport) {
      return FoodReportCard(
        foodReport: foodReport.foodFoodItem,
      );
    }).toList();
  }

  //TODO: actualizar el estado del reporte a revisado
  //TODO: agregar form para editar cantidad de los alimentos
  Future<bool> _saveMealReview(BuildContext context) async {
    bool exitReport = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reporte de comida'),
          content: const Text('El reporte ha sido revisado.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child:
                  const Text('Cerrar', style: TextStyle(color: Estilos.color1)),
            ),
          ],
        );
      },
    );
    return exitReport;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reporte de comida',
          style: TextStyle(color: Estilos.color5),
        ),
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () => _saveMealReview(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informacion de la comida:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Estilos.color1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Proteinas: ${protein}g"),
                          Text("Carbohidratos: ${carbs}g"),
                          Text("Grasas: ${fat}g"),
                          Text("Calorias: ${calories}g"),
                          Text(
                              "Fecha de grabación: ${mealReport.mealRecordedAt}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListOfFoodReports(
                  foodReports: getCards(),
                ),
              ),
              //TODO:este boton abre un form para elegir entre sugeridos y elegidos (patch request)
              Center(
                child: ElevatedButton(
                  onPressed: areSuggestions()
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuggestedFoodScreen(
                                foodItems: mealReport.foodReports,
                              ),
                            ),
                          );
                        },
                  child: const Text(
                    'Alternativas de alimentos',
                    style: TextStyle(
                      color: Estilos.color1,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
