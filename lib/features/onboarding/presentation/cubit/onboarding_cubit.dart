import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._prefs) : super(const OnboardingState());

  final SharedPreferences _prefs;

  static const _completedKey = 'onboarding_completed';

  static bool hasCompleted(SharedPreferences prefs) =>
      prefs.getBool(_completedKey) ?? false;

  void changePage(int index) => emit(state.copyWith(currentPage: index));

  Future<void> complete() => _prefs.setBool(_completedKey, true);
}
