import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/meal_log/domain/entities/logged_meal_entity.dart';
import '../../../../core/meal_log/domain/usecases/get_logged_meals_usecase.dart';

class HistoryState {
  const HistoryState({this.meals = const []});

  final List<LoggedMealEntity> meals;
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getLoggedMeals) : super(HistoryState(meals: _load(_getLoggedMeals))) {
    _subscription = _getLoggedMeals.watch().listen((_) {
      if (isClosed) return;
      emit(HistoryState(meals: _load(_getLoggedMeals)));
    });
  }

  final GetLoggedMealsUseCase _getLoggedMeals;
  late final StreamSubscription<void> _subscription;

  static List<LoggedMealEntity> _load(GetLoggedMealsUseCase useCase) {
    return useCase().fold(
      (failure) {
        if (kDebugMode) debugPrint('Failed to load logged meals: ${failure.message}');
        return const <LoggedMealEntity>[];
      },
      (meals) => meals,
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
