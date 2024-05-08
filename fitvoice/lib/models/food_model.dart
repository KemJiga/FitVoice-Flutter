class FoodModel {
  FoodModel({
    required this.id,
    required this.foodName,
    required this.otherNames,
    required this.description,
    required this.portionSize,
    required this.portionSizeUnit,
    required this.servingSize,
    required this.servingSizeUnit,
    required this.foodSource,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });
  String id;
  String foodName;
  String otherNames;
  String description;
  double portionSize;
  String portionSizeUnit;
  double servingSize;
  String servingSizeUnit;
  String foodSource;
  double calories;
  double protein;
  double fat;
  double carbohydrates;
}
