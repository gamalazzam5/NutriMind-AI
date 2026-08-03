import 'package:hive/hive.dart';

import '../models/logged_meal_hive_model.dart';

class MealLogLocalDataSource {
  MealLogLocalDataSource(this._box);

  final Box<LoggedMealHiveModel> _box;

  Future<void> add(LoggedMealHiveModel model) => _box.put(model.id, model);

  List<LoggedMealHiveModel> getAll() {
    final meals = _box.values.toList();
    meals.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return meals;
  }

  Stream<void> watch() => _box.watch().map((_) {});
}
