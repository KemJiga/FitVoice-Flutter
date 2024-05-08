import 'package:fitvoice/models/food_model.dart';

class FoodReportModel {
  const FoodReportModel({
    required this.id,
    required this.food,
    required this.score,
    required this.amount,
    required this.unitWasTransformed,
    required this.amountByUser,
  });

  final String id;
  final FoodModel food;
  final double score;
  final double amount;
  final bool unitWasTransformed;
  final bool amountByUser;
}
