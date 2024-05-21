class UserReportModel {
  UserReportModel({
    required this.foodName,
    required this.description,
    required this.amount,
    required this.unit,
  });

  String foodName;
  List<String> description;
  double amount;
  String unit;

  @override
  String toString() {
    return 'UserReportModel(foodName: $foodName, description: $description, amount: $amount, unit: $unit)';
  }

  String getDescription() {
    return description.join(',');
  }
}
