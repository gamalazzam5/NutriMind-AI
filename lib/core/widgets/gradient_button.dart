import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';

/// Pill-shaped gradient CTA button shared across features.
///
/// Pass [height] as `null` to size the button to its content padding
/// (e.g. the compact onboarding CTAs) instead of a fixed height.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient = AppColors.primaryGradient,
    this.isLoading = false,
    this.icon,
    this.iconTrailing = false,
    this.height,
    this.fullWidth = true,
    this.padding,
    this.showShadow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final bool isLoading;
  final IconData? icon;
  final bool iconTrailing;
  final double? height;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;
    final iconWidget = icon == null
        ? null
        : Icon(icon, color: Colors.white, size: 20.sp);

    final content = isLoading
        ? SizedBox(
            width: 22.w,
            height: 22.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconWidget != null && !iconTrailing) ...[
                iconWidget,
                SizedBox(width: 8.w),
              ],
              Text(label, style: AppTextStyles.button()),
              if (iconWidget != null && iconTrailing) ...[
                SizedBox(width: 8.w),
                iconWidget,
              ],
            ],
          );

    return Opacity(
      opacity: disabled && isLoading == false ? 0.5 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: height,
        padding: height == null
            ? (padding ?? EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h))
            : null,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: showShadow ? AppShadows.coloredGlow(AppColors.primaryEnd) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: disabled ? null : onPressed,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
