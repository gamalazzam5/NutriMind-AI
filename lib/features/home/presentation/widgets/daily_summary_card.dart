import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/macro_model.dart';
import 'calorie_progress_ring.dart';
import 'macro_chip.dart';

/// Bento-style card showing the calorie ring and macro breakdown for today.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.title,
    required this.caloriesConsumed,
    required this.calorieTarget,
    required this.kcalLabel,
    required this.macros,
    this.isArabic = false,
  });

  final String title;
  final int caloriesConsumed;
  final int calorieTarget;
  final String kcalLabel;
  final List<MacroModel> macros;
  final bool isArabic;

  static const _macroIcons = [
    Icons.set_meal_rounded,
    Icons.bakery_dining_rounded,
    Icons.water_drop_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: 0.08),
            blurRadius: 6.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.h2(isArabic: isArabic)),
          SizedBox(height: 24.h),
          CalorieProgressRing(
            current: caloriesConsumed,
            target: calorieTarget,
            kcalLabel: kcalLabel,
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < macros.length; i++) ...[
                if (i != 0) SizedBox(width: 12.w),
                MacroChip(macro: macros[i], icon: _macroIcons[i], isArabic: isArabic),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
