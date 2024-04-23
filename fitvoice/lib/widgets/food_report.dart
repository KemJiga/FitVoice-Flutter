import 'package:fitvoice/models/food_report_model.dart';
import 'package:flutter/material.dart';

class FoodReportCard extends StatelessWidget {
  const FoodReportCard({super.key, required this.foodReport});

  final FoodReportModel foodReport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('#${foodReport.id} - ${foodReport.foodName}'),
        //subtitle: Text('Descripcion: ${foodReport.description}'),
        children: [
          ListTile(
            title: Text('Cantidad: ${foodReport.amount} ${foodReport.unit}'),
          ),
          ListTile(
            title: Text('Proteinas: ${foodReport.protein}g'),
          ),
          ListTile(
            title: Text('Grasas: ${foodReport.fat}g'),
          ),
          ListTile(
            title: Text('Carbohidratos: ${foodReport.carbs}g'),
          ),
          ListTile(
            title: Text('Calorias: ${foodReport.calories}g'),
          ),
        ],
      ),
    );
  }
}
