import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/meal_log/domain/entities/logged_meal_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';

/// Full-width row tile used in the meal History list: thumbnail, title +
/// timestamp, and a kcal chip.
class LoggedMealListTile extends StatelessWidget {
  const LoggedMealListTile({super.key, required this.meal, this.isArabic = false});

  final LoggedMealEntity meal;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE2EBE0),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: meal.imagePath != null
                ? Image.file(File(meal.imagePath!), fit: BoxFit.cover)
                : Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.textSecondary,
                    size: 24.sp,
                  ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.foodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium(isArabic: isArabic)
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 15.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  formatMealTimestamp(meal.loggedAt),
                  style: AppTextStyles.bodySmall(isArabic: isArabic),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                '${meal.calories} ${'scanner_kcal'.tr()}',
                style: AppTextStyles.bodySmall(
                  color: const Color(0xFF006D37),
                  isArabic: isArabic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
