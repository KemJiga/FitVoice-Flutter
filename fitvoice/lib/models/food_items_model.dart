import 'package:fitvoice/models/food_report_model.dart';

class FoodItemsModel {
  final FoodReportModel? foodFoundItem;
  final List<FoodReportModel> suggestions;

  FoodItemsModel({
    required this.foodFoundItem,
    required this.suggestions,
  });
}
