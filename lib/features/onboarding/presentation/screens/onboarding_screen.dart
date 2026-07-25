import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboarding_page_model.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/onboarding_skip_button.dart';

const _pages = [
  OnboardingPageModel(
    imageAsset: 'assets/images/onboarding_scan.png',
    title: 'Smart AI Scanning',
    description:
        'Instant nutrition facts with just a photo. Our AI identifies ingredients and portions in seconds.',
    ctaLabel: 'Next',
  ),
  OnboardingPageModel(
    imageAsset: 'assets/images/onboarding_ai_chat.png',
    title: 'Personalized AI Advice',
    description:
        'Chat with NutriMind AI for tailored meal plans, macro advice, and healthy snack suggestions.',
    ctaLabel: 'Next',
  ),
  OnboardingPageModel(
    imageAsset: 'assets/images/onboarding_progress.png',
    title: 'Celebrate Your Wins',
    description:
        'Watch your health score grow as you log meals and maintain your streak. Build healthy habits that last.',
    ctaLabel: 'Get Started',
  ),
];

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next(int currentPage) {
    if (currentPage == _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _finish() {
    context.read<OnboardingCubit>().complete();
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) => PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) =>
                  context.read<OnboardingCubit>().changePage(index),
              itemBuilder: (context, index) => OnboardingPageContent(
                page: _pages[index],
                dotIndex: index,
                dotCount: _pages.length,
                onNext: () => _next(state.currentPage),
              ),
            ),
          ),
          Positioned(
            top: 36.h,
            right: 24.w,
            child: OnboardingSkipButton(onTap: _finish),
          ),
        ],
      ),
    );
  }
}
