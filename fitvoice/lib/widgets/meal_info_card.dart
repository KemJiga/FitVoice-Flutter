import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/screens/suggested_food_screen.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

class MealInfoCard extends StatelessWidget {
  const MealInfoCard(
      {super.key,
      required this.mrrId,
      required this.frrId,
      required this.userReport,
      required this.foodReports,
      required this.authToken});

  final String mrrId;
  final String frrId;
  final UserReportModel userReport;
  final FoodItemsModel foodReports;
  final String? authToken;

  @override
  Widget build(BuildContext context) {
    bool hasFoodReports = foodReports.foodFoundItem != null;
    if (hasFoodReports) {
      FoodModel food = foodReports.foodFoundItem!.food;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informacion entendida del usuario:',
                style: Estilos.textStyle1(18, Estilos.color3, 'bold'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Text(
                  userReport.amount.round() == 0
                      ? 'Una porcion de ${userReport.foodName}'
                      : '${userReport.amount.round()} ${userReport.unit} de ${userReport.foodName}',
                  style: Estilos.textStyle1(16, Colors.black, 'normal'),
                ),
              ),
              Text(
                'Informacion en base de datos:',
                style: Estilos.textStyle1(18, Estilos.color3, 'bold'),
              ),
              ExpansionTile(
                title: Text(
                  'Nombre: ${food.foodName}',
                  style: const TextStyle(
                    fontFamily: 'BrandonGrotesque',
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cantidad: ${foodReports.foodFoundItem!.amount.round()} gramos',
                      style: Estilos.textStyle1(15, Colors.black, 'normal'),
                    ),
                    Text(
                      'Descripcion: ${userReport.getDescription()}',
                      style: Estilos.textStyle1(15, Colors.black, 'normal'),
                    ),
                  ],
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Calorias: ${food.calories}',
                      style: const TextStyle(
                        fontFamily: 'BrandonGrotesque',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Proteinas: ${food.protein}g',
                      style: const TextStyle(
                        fontFamily: 'BrandonGrotesque',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Grasas: ${food.fat}g',
                      style: const TextStyle(
                        fontFamily: 'BrandonGrotesque',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Carbohidratos: ${food.carbohydrates}g',
                      style: const TextStyle(
                        fontFamily: 'BrandonGrotesque',
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuggestedFoodScreen(
                                mrrId: mrrId,
                                frrId: frrId,
                                userReport: userReport,
                                foodItems: foodReports,
                                authToken: authToken,
                              )),
                    );
                  },
                  child: Text(
                    'Editar',
                    style: Estilos.textStyle1(14, Estilos.color3, 'normal'),
                  ))
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informacion entendida del usuario:',
                style: Estilos.textStyle1(18, Estilos.color3, 'bold'),
              ),
              ExpansionTile(
                title: Text(
                  'Nombre: ${userReport.foodName}',
                  style: const TextStyle(
                    fontFamily: 'BrandonGrotesque',
                  ),
                ),
                subtitle: Text(
                  'Alimento no encontrado',
                  style: Estilos.textStyle1(14, Estilos.color5, 'bold'),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Cantidad: ${userReport.amount} ${userReport.unit}',
                      style: const TextStyle(
                        fontFamily: 'BrandonGrotesque',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
