import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/macro_model.dart';

/// Small pill card showing a macro's label, progress bar, and current/target.
class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.macro,
    required this.icon,
    this.isArabic = false,
  });

  final MacroModel macro;
  final IconData icon;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: macro.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    macro.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium(color: macro.color, isArabic: isArabic)
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(icon, size: 14.sp, color: macro.color),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: macro.progress,
                minHeight: 6.h,
                backgroundColor: macro.color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(macro.color),
              ),
            ),
            SizedBox(height: 8.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${macro.current.toInt()} / ${macro.target.toInt()}${macro.unit}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(
                  color: const Color(0xFF3D4A3E),
                  isArabic: isArabic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
