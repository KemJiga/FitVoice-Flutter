import 'package:fitvoice/models/food_report_model.dart';

class FoodItemsModel {
  final FoodReportModel foodFoodItem;
  final List<FoodReportModel> suggestions;

  FoodItemsModel({
    required this.foodFoodItem,
    required this.suggestions,
  });
}
