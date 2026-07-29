import 'package:dartz/dartz.dart';

import '../../../error/failures.dart';
import '../../domain/entities/logged_meal_entity.dart';
import '../../domain/repos/meal_log_repository.dart';
import '../datasources/meal_log_local_data_source.dart';
import '../models/logged_meal_hive_model.dart';

class MealLogRepositoryImpl implements MealLogRepository {
  MealLogRepositoryImpl(this._dataSource);

  final MealLogLocalDataSource _dataSource;

  @override
  Future<Either<Failure, void>> logMeal(LoggedMealEntity meal) async {
    try {
      await _dataSource.add(
        LoggedMealHiveModel(
          id: meal.id,
          foodName: meal.foodName,
          calories: meal.calories,
          healthScore: meal.healthScore,
          proteinGrams: meal.proteinGrams,
          carbsGrams: meal.carbsGrams,
          fatGrams: meal.fatGrams,
          imagePath: meal.imagePath,
          loggedAt: meal.loggedAt,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Could not save this meal: $e'));
    }
  }

  @override
  Either<Failure, List<LoggedMealEntity>> getLoggedMeals() {
    try {
      final meals = _dataSource
          .getAll()
          .map(
            (m) => LoggedMealEntity(
              id: m.id,
              foodName: m.foodName,
              calories: m.calories,
              healthScore: m.healthScore,
              proteinGrams: m.proteinGrams,
              carbsGrams: m.carbsGrams,
              fatGrams: m.fatGrams,
              imagePath: m.imagePath,
              loggedAt: m.loggedAt,
            ),
          )
          .toList();
      return Right(meals);
    } catch (e) {
      return Left(UnknownFailure('Could not load logged meals: $e'));
    }
  }

  @override
  Stream<void> watchLoggedMeals() => _dataSource.watch();
}
