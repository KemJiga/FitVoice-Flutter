import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/unit_transformation_info.dart';

class FoodReportModel {
  const FoodReportModel({
    required this.id,
    required this.food,
    required this.score,
    required this.amount,
    required this.unitWasTransformed,
    required this.amountByUser,
    required this.servingSizeWasUsed,
    this.unitTransformationInfo,
  });

  final String id;
  final FoodModel food;
  final double score;
  final double amount;
  final bool unitWasTransformed; // unidad transformada (1 taza -> 200 gramos)
  final bool amountByUser; //cantidad modificada por el usuario
  final bool servingSizeWasUsed; // Usando cantidad * serving size
  final UnitTransformationInfo? unitTransformationInfo;

  @override
  String toString() {
    return 'FoodReportModel(id: $id, food: $food, score: $score, amount: $amount, unitWasTransformed: $unitWasTransformed, amountByUser: $amountByUser)';
  }
}
