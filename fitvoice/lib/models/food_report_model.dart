class FoodReportModel {
  const FoodReportModel({
    required this.id,
    required this.foodName,
    required this.description,
    required this.amount,
    required this.unit,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.calories,
  });

  final String id;
  final String foodName;
  final String description;
  final double amount;
  final String unit;
  final int protein;
  final int fat;
  final int carbs;
  final int calories;
}
