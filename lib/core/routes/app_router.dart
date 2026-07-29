import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/shell/presentation/screens/main_shell_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        );
      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const MainShellScreen(),
          ),
        );
      case AppRoutes.history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
