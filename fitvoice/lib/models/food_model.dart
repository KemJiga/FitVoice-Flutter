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
  List<String> otherNames;
  List<String> description;
  double portionSize;
  String portionSizeUnit;
  double servingSize;
  String servingSizeUnit;
  String foodSource;
  double calories;
  double protein;
  double fat;
  double carbohydrates;

  @override
  String toString() {
    return 'FoodModel(id: $id, foodName: $foodName, otherNames: $otherNames, description: $description, portionSize: $portionSize, portionSizeUnit: $portionSizeUnit, servingSize: $servingSize, servingSizeUnit: $servingSizeUnit, foodSource: $foodSource, calories: $calories, protein: $protein, fat: $fat, carbohydrates: $carbohydrates)';
  }

  String getDescription() {
    return description.join(', ');
  }

  String getOtherNames() {
    return otherNames.join(', ');
  }
}
