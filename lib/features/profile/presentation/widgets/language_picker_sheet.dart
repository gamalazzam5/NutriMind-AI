import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Bottom sheet letting the user switch the app language between English
/// and Arabic. Selecting an option updates the app locale immediately via
/// easy_localization, which persists the choice automatically.
Future<void> showLanguagePicker(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => const _LanguagePickerSheet(),
  );
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final currentLocale = context.locale;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: const Color(0xFFBBCBBB),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'profile_language_sheet_title'.tr(),
            style: AppTextStyles.h3(isArabic: isArabic),
          ),
          SizedBox(height: 16.h),
          for (final locale in context.supportedLocales)
            _LanguageOption(
              label: (locale.languageCode == 'ar'
                      ? 'profile_language_arabic'
                      : 'profile_language_english')
                  .tr(),
              isSelected: locale.languageCode == currentLocale.languageCode,
              isArabic: isArabic,
              onTap: () {
                context.setLocale(locale);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.isArabic,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected ? AppColors.primaryStart : AppColors.divider,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyLarge(isArabic: isArabic)),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryStart,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
