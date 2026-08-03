import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

class ScannerIdleView extends StatelessWidget {
  const ScannerIdleView({
    super.key,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
  });

  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B1F14), Color(0xFF163526)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  Icons.document_scanner_outlined,
                  size: 40.sp,
                  color: AppColors.primaryStart,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'scanner_idle_title'.tr(),
                style: AppTextStyles.h2(color: Colors.white, isArabic: isArabic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'scanner_idle_subtitle'.tr(),
                style: AppTextStyles.bodyMedium(
                  color: Colors.white.withValues(alpha: 0.7),
                  isArabic: isArabic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  onTap: onTakePhoto,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.ctaGradient,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'scanner_take_photo'.tr(),
                          style: AppTextStyles.button(isArabic: isArabic),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: onChooseFromGallery,
                child: Text(
                  'scanner_choose_from_gallery'.tr(),
                  style: AppTextStyles.bodyMedium(
                    color: Colors.white,
                    isArabic: isArabic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
