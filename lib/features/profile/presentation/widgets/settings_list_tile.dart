import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/settings_item_model.dart';

/// Single row in the profile settings list card.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.item,
    required this.onTap,
    this.showDivider = true,
    this.isArabic = false,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });

  final SettingsItemModel item;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isArabic;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(top: BorderSide(color: Color(0xFFDCE5DA)))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: (iconColor ?? const Color(0xFF006D37)).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      size: 20.sp,
                      color: iconColor ?? const Color(0xFF006D37),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    item.label,
                    style: labelColor == null
                        ? AppTextStyles.bodyLarge(isArabic: isArabic)
                        : AppTextStyles.bodyLarge(isArabic: isArabic, color: labelColor!),
                  ),
                ],
              ),
              trailing ??
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    size: 20.sp,
                    color: AppColors.textSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
