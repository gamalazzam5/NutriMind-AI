import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/macro_model.dart';
import '../../data/models/meal_model.dart';
import '../widgets/action_tile.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/meal_card.dart';

const _recentMeals = [
  MealModel(
    name: 'Avocado Toast',
    subtitle: 'Breakfast • 8:30 AM',
    calories: 320,
    imageAsset: 'assets/images/meal_avocado_toast.jpg',
  ),
  MealModel(
    name: 'Quinoa Power Bowl',
    subtitle: 'Lunch • 1:15 PM',
    calories: 540,
    imageAsset: 'assets/images/meal_quinoa_bowl.jpg',
  ),
  MealModel(name: 'Log Snack', subtitle: 'Quick entry', calories: 0),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onScanFoodTap});

  /// Switches the shell to the Scanner tab. Null falls back to a snackbar
  /// (used when Home is previewed outside the shell).
  final VoidCallback? onScanFoodTap;

  void _showComingSoon(BuildContext context, String label, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — ${l10n.t('home_coming_soon')}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final macros = [
      MacroModel(
        label: l10n.t('home_protein'),
        current: 75,
        target: 100,
        unit: 'g',
        color: AppColors.macroProtein,
      ),
      MacroModel(
        label: l10n.t('home_carbs'),
        current: 120,
        target: 240,
        unit: 'g',
        color: AppColors.macroCarbs,
      ),
      MacroModel(
        label: l10n.t('home_fat'),
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
                title: l10n.t('home_daily_summary'),
                caloriesConsumed: 1450,
                calorieTarget: 2200,
                kcalLabel: l10n.t('scanner_kcal'),
                macros: macros,
                isArabic: l10n.isArabic,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  ActionTile(
                    title: l10n.t('home_scan_food'),
                    subtitle: l10n.t('home_scan_food_subtitle'),
                    icon: Icons.camera_alt_rounded,
                    iconColor: AppColors.primaryStart,
                    isArabic: l10n.isArabic,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryStart.withValues(alpha: 0.2),
                        AppColors.ctaStart.withValues(alpha: 0.2),
                      ],
                    ),
                    onTap: onScanFoodTap ??
                        () => _showComingSoon(context, l10n.t('home_scan_food'), l10n),
                  ),
                  SizedBox(width: 16.w),
                  ActionTile(
                    title: l10n.t('home_ask_ai'),
                    subtitle: l10n.t('home_ask_ai_subtitle'),
                    icon: Icons.auto_awesome_rounded,
                    iconColor: const Color(0xFF5D48CA),
                    borderColor: AppColors.lavender.withValues(alpha: 0.3),
                    isArabic: l10n.isArabic,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lavender.withValues(alpha: 0.3),
                        const Color(0xFF5D48CA).withValues(alpha: 0.2),
                      ],
                    ),
                    onTap: () => _showComingSoon(context, l10n.t('home_ask_ai'), l10n),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.t('home_recent_meals'),
                    style: AppTextStyles.h2(isArabic: l10n.isArabic),
                  ),
                  TextButton(
                    onPressed: () =>
                        _showComingSoon(context, l10n.t('home_recent_meals'), l10n),
                    child: Text(
                      l10n.t('home_view_all'),
                      style: AppTextStyles.bodySmall(
                        color: const Color(0xFF006D37),
                        isArabic: l10n.isArabic,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 172.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentMeals.length,
                  separatorBuilder: (_, _) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) => MealCard(
                    meal: _recentMeals[index],
                    kcalLabel: l10n.t('scanner_kcal'),
                    isArabic: l10n.isArabic,
                    onTap: () =>
                        _showComingSoon(context, _recentMeals[index].name, l10n),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
