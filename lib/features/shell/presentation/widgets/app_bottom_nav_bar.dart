import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

class _NavItem {
  const _NavItem(this.icon, this.labelKey);
  final IconData icon;
  final String labelKey;
}

const _navItems = [
  _NavItem(Icons.home_rounded, 'nav_home'),
  _NavItem(Icons.document_scanner_outlined, 'nav_scanner'),
  _NavItem(Icons.smart_toy_outlined, 'nav_chat'),
  _NavItem(Icons.person_outline_rounded, 'nav_profile'),
];

/// Frosted, pill-tabbed bottom navigation bar shared across the main app shell.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF3FCF1).withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryStart.withValues(alpha: 0.08),
              blurRadius: 12.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _navItems.length; i++)
                  _NavButton(
                    item: _navItems[i],
                    isActive: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = isActive ? const Color(0xFF006D37) : AppColors.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryStart.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 20.sp, color: color),
              SizedBox(height: 4.h),
              Text(
                l10n.t(item.labelKey),
                style: AppTextStyles.caption(color: color, isArabic: l10n.isArabic)
                    .copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
