import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/meal_thumb_card.dart';
import '../../data/models/macro_model.dart';
import '../cubit/home_cubit.dart';
import '../widgets/action_tile.dart';
import '../widgets/daily_summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onScanFoodTap, this.onAskAiTap});


  final VoidCallback? onScanFoodTap;
  final VoidCallback? onAskAiTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: _HomeView(onScanFoodTap: onScanFoodTap, onAskAiTap: onAskAiTap),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({this.onScanFoodTap, this.onAskAiTap});

  final VoidCallback? onScanFoodTap;
  final VoidCallback? onAskAiTap;

  void _showComingSoon(BuildContext context, String label) {
    AppSnackBar.info(context, '$label — ${'home_coming_soon'.tr()}');
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final macros = [
      MacroModel(
        label: 'home_protein'.tr(),
        current: 75,
        target: 100,
        unit: 'g',
        color: AppColors.macroProtein,
      ),
      MacroModel(
        label: 'home_carbs'.tr(),
        current: 120,
        target: 240,
        unit: 'g',
        color: AppColors.macroCarbs,
      ),
      MacroModel(
        label: 'home_fat'.tr(),
        current: 40,
        target: 50,
        unit: 'g',
        color: AppColors.macroFat,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DailySummaryCard(
                title: 'home_daily_summary'.tr(),
                caloriesConsumed: 1450,
                calorieTarget: 2200,
                kcalLabel: 'scanner_kcal'.tr(),
                macros: macros,
                isArabic: isArabic,
              ),
              SizedBox(height: 16.h),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ActionTile(
                      title: 'home_scan_food'.tr(),
                      subtitle: 'home_scan_food_subtitle'.tr(),
                      icon: Icons.camera_alt_rounded,
                      iconColor: AppColors.primaryStart,
                      isArabic: isArabic,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryStart.withValues(alpha: 0.2),
                          AppColors.ctaStart.withValues(alpha: 0.2),
                        ],
                      ),
                      onTap: onScanFoodTap ??
                          () => _showComingSoon(context, 'home_scan_food'.tr()),
                    ),
                    SizedBox(width: 16.w),
                    ActionTile(
                      title: 'home_ask_ai'.tr(),
                      subtitle: 'home_ask_ai_subtitle'.tr(),
                      icon: Icons.auto_awesome_rounded,
                      iconColor: const Color(0xFF5D48CA),
                      borderColor: AppColors.lavender.withValues(alpha: 0.3),
                      isArabic: isArabic,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lavender.withValues(alpha: 0.3),
                          const Color(0xFF5D48CA).withValues(alpha: 0.2),
                        ],
                      ),
                      onTap: onAskAiTap ??
                          () => _showComingSoon(context, 'home_ask_ai'.tr()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'home_recent_meals'.tr(),
                    style: AppTextStyles.h2(isArabic: isArabic),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
                    child: Text(
                      'home_view_all'.tr(),
                      style: AppTextStyles.bodySmall(
                        color: const Color(0xFF006D37),
                        isArabic: isArabic,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.recentMeals.isEmpty) {
                    return SizedBox(
                      height: 96.h,
                      child: Center(
                        child: Text(
                          'history_empty'.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall(isArabic: isArabic),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 172.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recentMeals.length,
                      separatorBuilder: (_, _) => SizedBox(width: 16.w),
                      itemBuilder: (context, index) => MealThumbCard(
                        meal: state.recentMeals[index],
                        kcalLabel: 'scanner_kcal'.tr(),
                        isArabic: isArabic,
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.history),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
