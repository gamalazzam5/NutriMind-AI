import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/scan_result_entity.dart';
import 'health_score_badge.dart';

/// Bottom sheet showing the AI scan's identified meal and macro breakdown,
/// with a CTA to log it.
class ScanResultSheet extends StatelessWidget {
  const ScanResultSheet({super.key, required this.result, required this.onLog});

  final ScanResultEntity result;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3FCF1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl * 2),
          topRight: Radius.circular(AppRadius.xl * 2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: 0.12),
            blurRadius: 12.r,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 48.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFFBBCBBB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.foodName,
                              style: AppTextStyles.h2(isArabic: l10n.isArabic),
                            ),
                            SizedBox(height: 4.h),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${result.calories} ',
                                    style: AppTextStyles.h1(color: const Color(0xFF006D37))
                                        .copyWith(fontSize: 40.sp, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    l10n.t('scanner_kcal'),
                                    style: AppTextStyles.bodySmall(
                                      color: const Color(0xFF3D4A3E),
                                      isArabic: l10n.isArabic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      HealthScoreBadge(score: result.healthScore),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      _MacroPill(
                        label: l10n.t('home_protein'),
                        value: '${result.proteinGrams}g',
                        color: const Color(0xFFFD7958),
                        isArabic: l10n.isArabic,
                      ),
                      SizedBox(width: 12.w),
                      _MacroPill(
                        label: l10n.t('home_carbs'),
                        value: '${result.carbsGrams}g',
                        color: const Color(0xFF5D48CA),
                        isArabic: l10n.isArabic,
                      ),
                      SizedBox(width: 12.w),
                      _MacroPill(
                        label: l10n.t('home_fat'),
                        value: '${result.fatGrams}g',
                        color: const Color(0xFF006D37),
                        isArabic: l10n.isArabic,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      onTap: onLog,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.ctaGradient,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryStart.withValues(alpha: 0.2),
                              blurRadius: 8.r,
                              offset: Offset(0, 8.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
                            SizedBox(width: 8.w),
                            Text(
                              l10n.t('scanner_log_meal'),
                              style: AppTextStyles.bodyMedium(
                                color: Colors.white,
                                isArabic: l10n.isArabic,
                              ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
    required this.isArabic,
  });

  final String label;
  final String value;
  final Color color;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall(
                color: const Color(0xFF3D4A3E),
                isArabic: isArabic,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.bodyMedium(color: color, isArabic: isArabic)
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
