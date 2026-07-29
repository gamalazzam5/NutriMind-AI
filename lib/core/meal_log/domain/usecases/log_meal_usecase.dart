import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../entities/logged_meal_entity.dart';
import '../repos/meal_log_repository.dart';

class LogMealUseCase {
  LogMealUseCase(this._repository);

  final MealLogRepository _repository;

  Future<Either<Failure, void>> call(LoggedMealEntity meal) =>
      _repository.logMeal(meal);
}
