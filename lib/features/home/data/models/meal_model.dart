/// Display model for a recently logged meal card.
class MealModel {
  final String name;
  final String subtitle;
  final int calories;
  final String? imageAsset;

  const MealModel({
    required this.name,
    required this.subtitle,
    required this.calories,
    this.imageAsset,
  });
}
