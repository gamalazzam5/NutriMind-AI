import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Bento action tile used for "Scan Food" and "Ask AI" quick actions.
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.gradient,
    required this.onTap,
    this.borderColor,
    this.isArabic = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Gradient gradient;
  final Color? borderColor;
  final VoidCallback onTap;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22.sp),
                ),
                SizedBox(height: 16.h),
                Text(title, style: AppTextStyles.h3(isArabic: isArabic)),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(
                    color: const Color(0xFF3D4A3E),
                    isArabic: isArabic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
