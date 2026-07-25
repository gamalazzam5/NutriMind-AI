import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

final getIt = GetIt.instance;

/// Registers app-wide dependencies. Feature modules add their own
/// `init{Feature}Dependencies()` calls here as they're scaffolded.
Future<void> initDependencies() async {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    return dio;
  });

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerFactory(() => OnboardingCubit(getIt<SharedPreferences>()));
}
