import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HealthScoreBadge extends StatelessWidget {
  const HealthScoreBadge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.r,
      height: 64.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4.r,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.primaryStart.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryStart),
          ),
          Text(
            '$score',
            style: AppTextStyles.bodyMedium(color: const Color(0xFF006D37))
                .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
