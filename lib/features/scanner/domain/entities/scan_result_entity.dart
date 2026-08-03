class ScanResultEntity {
  final String foodName;
  final int calories;
  final int healthScore;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;

  const ScanResultEntity({
    required this.foodName,
    required this.calories,
    required this.healthScore,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });
}
