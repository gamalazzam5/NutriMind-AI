import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum _AppSnackBarType { success, error, info }

/// A single themed snackbar used across the app so every user-facing action
/// (log meal, send message, coming-soon taps, auth errors, ...) looks and
/// behaves consistently.
abstract final class AppSnackBar {
  static void success(BuildContext context, String message) =>
      _show(context, message, _AppSnackBarType.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, _AppSnackBarType.error);

  static void info(BuildContext context, String message) =>
      _show(context, message, _AppSnackBarType.info);

  static void _show(BuildContext context, String message, _AppSnackBarType type) {
    final (icon, color) = switch (type) {
      _AppSnackBarType.success => (Icons.check_circle_rounded, AppColors.primaryStart),
      _AppSnackBarType.error => (Icons.error_rounded, AppColors.error),
      _AppSnackBarType.info => (Icons.info_rounded, AppColors.lavender),
    };

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          elevation: 0,
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium(
                    color: Colors.white,
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
