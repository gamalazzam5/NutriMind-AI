import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Coral gradient promo card prompting the user to upgrade to Pro.
class UpgradeProCard extends StatelessWidget {
  const UpgradeProCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.body,
    required this.ctaLabel,
    this.isArabic = false,
  });

  final VoidCallback onTap;
  final String title;
  final String body;
  final String ctaLabel;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFD7958), Color(0xFFA7391E)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h2(color: Colors.white, isArabic: isArabic),
          ),
          SizedBox(height: 4.h),
          Opacity(
            opacity: 0.9,
            child: Text(
              body,
              style: AppTextStyles.bodyLarge(color: Colors.white, isArabic: isArabic),
            ),
          ),
          SizedBox(height: 16.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Text(
                  ctaLabel,
                  style: AppTextStyles.bodySmall(
                    color: const Color(0xFFFD7958),
                    isArabic: isArabic,
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
