import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/profile_stat_model.dart';

/// White bento tile showing a single profile stat (streak, meals, score).
class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({super.key, required this.stat, this.isArabic = false});

  final ProfileStatModel stat;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryStart.withValues(alpha: 0.08),
              blurRadius: 6.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(stat.icon, size: 18.sp, color: AppColors.primaryStart),
            SizedBox(height: 8.h),
            Text(stat.value, style: AppTextStyles.h2(isArabic: isArabic)),
            SizedBox(height: 4.h),
            Text(
              stat.label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(isArabic: isArabic).copyWith(letterSpacing: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
