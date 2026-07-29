/// A meal that was logged after an AI scan, persisted locally.
class LoggedMealEntity {
  final String id;
  final String foodName;
  final int calories;
  final int healthScore;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String? imagePath;
  final DateTime loggedAt;

  const LoggedMealEntity({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.healthScore,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.loggedAt,
    this.imagePath,
  });
}
