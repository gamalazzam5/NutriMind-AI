import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repository_impl.dart';
import '../../features/auth/domain/repos/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
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

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.instance);
  getIt.registerLazySingleton(
    () => AuthRemoteDataSource(getIt<FirebaseAuth>(), getIt<GoogleSignIn>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => SignInWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(
    () => AuthCubit(
      getIt<SignInWithEmailUseCase>(),
      getIt<SignUpWithEmailUseCase>(),
      getIt<SignInWithGoogleUseCase>(),
      getIt<SignOutUseCase>(),
    ),
  );

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
