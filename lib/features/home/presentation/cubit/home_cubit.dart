import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/meal_log/domain/entities/logged_meal_entity.dart';
import '../../../../core/meal_log/domain/usecases/get_logged_meals_usecase.dart';

const _recentMealsLimit = 5;

class HomeState {
  const HomeState({this.recentMeals = const []});

  final List<LoggedMealEntity> recentMeals;
}


class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getLoggedMeals) : super(HomeState(recentMeals: _recent(_getLoggedMeals))) {
    _subscription = _getLoggedMeals.watch().listen((_) {
      if (isClosed) return;
      emit(HomeState(recentMeals: _recent(_getLoggedMeals)));
    });
  }

  final GetLoggedMealsUseCase _getLoggedMeals;
  late final StreamSubscription<void> _subscription;

  static List<LoggedMealEntity> _recent(GetLoggedMealsUseCase useCase) {
    return useCase().fold(
      (failure) {
        if (kDebugMode) debugPrint('Failed to load recent meals: ${failure.message}');
        return const <LoggedMealEntity>[];
      },
      (meals) => meals.take(_recentMealsLimit).toList(),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
