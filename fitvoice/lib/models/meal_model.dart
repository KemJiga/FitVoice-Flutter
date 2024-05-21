import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/user_report_model.dart';

class MealModel {
  final String id;
  final UserReportModel userReport;
  final FoodItemsModel foodReports;

  MealModel({
    required this.id,
    required this.userReport,
    required this.foodReports,
  });
}
