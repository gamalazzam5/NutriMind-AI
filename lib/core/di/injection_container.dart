import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/repos/chat_repository_impl.dart';
import '../../features/chat/domain/repos/chat_repository.dart';
import '../../features/chat/domain/usecases/send_chat_image_message_usecase.dart';
import '../../features/chat/domain/usecases/send_chat_text_message_usecase.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/scanner/data/datasources/scanner_remote_data_source.dart';
import '../../features/scanner/data/repos/scanner_repository_impl.dart';
import '../../features/scanner/domain/repos/scanner_repository.dart';
import '../../features/scanner/domain/usecases/analyze_food_image_usecase.dart';
import '../../features/scanner/presentation/cubit/scanner_cubit.dart';

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

  getIt.registerLazySingleton(() => ChatRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => SendChatTextMessageUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => SendChatImageMessageUseCase(getIt<ChatRepository>()));
  getIt.registerFactory(
    () => ChatCubit(getIt<SendChatTextMessageUseCase>(), getIt<SendChatImageMessageUseCase>()),
  );

  getIt.registerLazySingleton(() => ImagePicker());

  getIt.registerLazySingleton(() => ScannerRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(getIt<ScannerRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => AnalyzeFoodImageUseCase(getIt<ScannerRepository>()));
  getIt.registerFactory(
    () => ScannerCubit(getIt<ImagePicker>(), getIt<AnalyzeFoodImageUseCase>()),
  );
}
