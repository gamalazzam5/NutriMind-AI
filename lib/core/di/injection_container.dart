import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/scanner/presentation/cubit/scanner_cubit.dart';
import '../localization/locale_cubit.dart';

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
  getIt.registerFactory(() => ChatCubit());
  getIt.registerLazySingleton(() => LocaleCubit(getIt<SharedPreferences>()));

  getIt.registerLazySingleton(() => ImagePicker());
  getIt.registerFactory(() => ScannerCubit(getIt<ImagePicker>()));
}
