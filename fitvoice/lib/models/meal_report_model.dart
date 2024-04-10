import 'food_report_model.dart';

class MealReportModel {
  late String id;
  late String appUserId;
  late String audioId;
  late String rawTranscript;
  late List<FoodReportReview> foodReports;
  late String dbLookupPreference;
  late DateTime mealRecordedAt;
  late bool pending;
  late bool reviewed;
}
