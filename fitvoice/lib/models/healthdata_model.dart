enum Gender { hombre, mujer }

class HealthData {
  HealthData({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  });

  int age;
  int height;
  double weight;
  Gender gender;
}
