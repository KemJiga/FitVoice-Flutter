import 'package:fitvoice/models/meal_model.dart';

class MealReportModel {
  MealReportModel({
    required this.id,
    required this.appUserId,
    required this.audioId,
    required this.rawTranscript,
    this.foodReports,
    required this.dbLookupPreference,
    required this.mealRecordedAt,
    required this.pending,
  });

  String id;
  String appUserId;
  String audioId;
  String rawTranscript;
  List<MealModel>? foodReports;
  String dbLookupPreference;
  DateTime mealRecordedAt;
  bool pending;

  @override
  String toString() {
    return 'MealReportModel(id: $id, appUserId: $appUserId, audioId: $audioId, rawTranscript: $rawTranscript, foodReports: $foodReports, dbLookupPreference: $dbLookupPreference, mealRecordedAt: $mealRecordedAt, pending: $pending)';
  }
}
