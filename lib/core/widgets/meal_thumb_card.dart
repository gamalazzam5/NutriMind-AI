import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../meal_log/domain/entities/logged_meal_entity.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_format.dart';

/// Meal thumbnail card used in the horizontally scrolling "Recent Meals" row
/// on Home and (as a grid) on the meal History screen.
class MealThumbCard extends StatelessWidget {
  const MealThumbCard({
    super.key,
    required this.meal,
    required this.kcalLabel,
    this.onTap,
    this.isArabic = false,
  });

  final LoggedMealEntity meal;
  final String kcalLabel;
  final VoidCallback? onTap;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: SizedBox(
          width: 160.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 112.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EBE0),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryStart.withValues(alpha: 0.08),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (meal.imagePath != null)
                      Image.file(File(meal.imagePath!), fit: BoxFit.cover)
                    else
                      Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.textSecondary,
                        size: 25.sp,
                      ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3FCF1).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '${meal.calories} $kcalLabel',
                              style: AppTextStyles.bodySmall(
                                color: const Color(0xFF006D37),
                                isArabic: isArabic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                meal.foodName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium(isArabic: isArabic)
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
              Text(
                formatMealTimestamp(meal.loggedAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(
                  color: const Color(0xFF3D4A3E),
                  isArabic: isArabic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
