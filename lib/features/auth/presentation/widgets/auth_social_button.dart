import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "Continue with Google/Apple" pill used on Login and Register.
class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: isLoading ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBBCBBB)),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Color(0xFF161D17)),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(iconAsset, width: 20.w, height: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          label,
                          style: AppTextStyles.bodyMedium(color: const Color(0xFF161D17))
                              .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.14),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
