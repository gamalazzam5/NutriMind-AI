import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../entities/logged_meal_entity.dart';

abstract class MealLogRepository {
  Future<Either<Failure, void>> logMeal(LoggedMealEntity meal);

  Either<Failure, List<LoggedMealEntity>> getLoggedMeals();

  Stream<void> watchLoggedMeals();
}
