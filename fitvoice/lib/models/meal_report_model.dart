import 'package:fitvoice/models/food_items_model.dart';

class MealReportModel {
  MealReportModel({
    required this.id,
    required this.appUserId,
    required this.audioId,
    required this.rawTranscript,
    required this.foodReports,
    required this.dbLookupPreference,
    required this.mealRecordedAt,
    required this.pending,
    required this.reviewed,
  });
  String id;
  String appUserId;
  String audioId;
  String rawTranscript;
  List<FoodItemsModel> foodReports;
  String dbLookupPreference;
  DateTime mealRecordedAt;
  bool pending;
  bool reviewed;
}
