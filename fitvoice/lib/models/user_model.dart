import 'package:fitvoice/models/healthdata_model.dart';

class UserModel {
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.healthData,
  });

  String firstName;
  String lastName;
  String email;
  String password;
  HealthData? healthData;
}
