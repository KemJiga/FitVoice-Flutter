class UnitTransformationInfo {
  final String originalUnit;
  final String finalUnit;
  final double transformationFactor;

  UnitTransformationInfo(
      {required this.originalUnit,
      required this.finalUnit,
      required this.transformationFactor});
}
