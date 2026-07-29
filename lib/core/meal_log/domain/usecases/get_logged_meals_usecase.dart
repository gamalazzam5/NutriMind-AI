import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../entities/logged_meal_entity.dart';
import '../repos/meal_log_repository.dart';

class GetLoggedMealsUseCase {
  GetLoggedMealsUseCase(this._repository);

  final MealLogRepository _repository;

  Either<Failure, List<LoggedMealEntity>> call() => _repository.getLoggedMeals();

  Stream<void> watch() => _repository.watchLoggedMeals();
}
