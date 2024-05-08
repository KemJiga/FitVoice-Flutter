import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/user_report_model.dart';

class MealReportModel {
  MealReportModel({
    required this.userReport,
    required this.id,
    required this.appUserId,
    required this.audioId,
    required this.rawTranscript,
    required this.foodReports,
    required this.dbLookupPreference,
    required this.mealRecordedAt,
    required this.pending,
  });

  String id;
  String appUserId;
  String audioId;
  String rawTranscript;
  UserReportModel userReport;
  FoodItemsModel foodReports;
  String dbLookupPreference;
  DateTime mealRecordedAt;
  bool pending;
}
