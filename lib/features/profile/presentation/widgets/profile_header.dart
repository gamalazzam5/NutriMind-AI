import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Avatar + name + streak badge shown at the top of the profile screen.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatarAsset,
    required this.streakDays,
    this.isArabic = false,
  });

  final String name;
  final String subtitle;
  final String avatarAsset;
  final int streakDays;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 128.r,
              height: 128.r,
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryStart.withValues(alpha: 0.12),
                    blurRadius: 6.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF3FCF1), width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(avatarAsset, fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryStart,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF3FCF1), width: 2),
                ),
                child: Text(
                  '$streakDays🔥',
                  style: AppTextStyles.bodySmall(color: const Color(0xFF005027))
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: AppTextStyles.h1(isArabic: isArabic),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: AppTextStyles.bodyLarge(color: const Color(0xFF3D4A3E), isArabic: isArabic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
