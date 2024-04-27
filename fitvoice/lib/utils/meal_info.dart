import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/meal_report_model.dart';

class MealInfoExtractor {
  //verify if list is null
  MealInfoExtractor({
    required this.foodReports,
  });

  final List<FoodItemsModel> foodReports;
  int protein = 0;
  int fat = 0;
  int carbs = 0;
  int calories = 0;

  static bool isMealEmpty(List<FoodItemsModel> foodReports) {
    return foodReports.isEmpty;
  }

  List<int> getMealInfo(List<FoodItemsModel>? reports) {
    if (reports == null) {
      getFoodInfo(foodReports);
    } else {
      getFoodInfo(reports);
    }
    return [protein, fat, carbs, calories];
  }

  List<MealReportModel> getTodayFoodReports(List<MealReportModel> reports) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return reports
        .where((element) => element.mealRecordedAt.isAfter(today))
        .toList();
  }

  void getFoodInfo(List<FoodItemsModel> foodReports) {
    for (var foodReport in foodReports) {
      protein += foodReport.foodFoodItem.protein;
      fat += foodReport.foodFoodItem.fat;
      carbs += foodReport.foodFoodItem.carbs;
      calories += foodReport.foodFoodItem.calories;
    }
  }
}
