import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../entities/logged_meal_entity.dart';

abstract class MealLogRepository {
  Future<Either<Failure, void>> logMeal(LoggedMealEntity meal);

  /// Most recently logged meals first.
  Either<Failure, List<LoggedMealEntity>> getLoggedMeals();

  /// Notifies whenever the log changes, for reactive UI.
  Stream<void> watchLoggedMeals();
}
