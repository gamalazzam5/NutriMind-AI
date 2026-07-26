import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/profile_stat_model.dart';
import '../../data/models/settings_item_model.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/upgrade_pro_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String label, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — ${l10n.t('home_coming_soon')}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = context.watch<LocaleCubit>().state;
    final currentLanguageLabel = l10n.t(
      currentLocale.languageCode == 'ar'
          ? 'profile_language_arabic'
          : 'profile_language_english',
    );

    final stats = [
      ProfileStatModel(
        icon: Icons.local_fire_department_rounded,
        value: '12',
        label: l10n.t('profile_day_streak'),
      ),
      ProfileStatModel(
        icon: Icons.restaurant_rounded,
        value: '142',
        label: l10n.t('profile_meals_logged'),
      ),
      ProfileStatModel(
        icon: Icons.shield_rounded,
        value: '92',
        label: l10n.t('profile_avg_score'),
      ),
    ];

    final settingsItems = [
      SettingsItemModel(
        icon: Icons.track_changes_rounded,
        label: l10n.t('profile_health_goals'),
      ),
      SettingsItemModel(icon: Icons.cable_rounded, label: l10n.t('profile_integrations')),
      SettingsItemModel(
        icon: Icons.notifications_none_rounded,
        label: l10n.t('profile_notifications'),
      ),
      SettingsItemModel(icon: Icons.help_outline_rounded, label: l10n.t('profile_support')),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(
                name: 'Alex Rivera',
                subtitle: l10n.t('profile_wellness_enthusiast'),
                avatarAsset: 'assets/images/profile_avatar.jpg',
                streakDays: 12,
                isArabic: l10n.isArabic,
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      if (i != 0) SizedBox(width: 16.w),
                      ProfileStatCard(stat: stats[i], isArabic: l10n.isArabic),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              UpgradeProCard(
                title: l10n.t('profile_upgrade_title'),
                body: l10n.t('profile_upgrade_body'),
                ctaLabel: l10n.t('profile_join_premium'),
                isArabic: l10n.isArabic,
                onTap: () => _showComingSoon(context, l10n.t('profile_join_premium'), l10n),
              ),
              SizedBox(height: 40.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryStart.withValues(alpha: 0.08),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SettingsListTile(
                        item: SettingsItemModel(
                          icon: Icons.language_rounded,
                          label: l10n.t('profile_language'),
                        ),
                        showDivider: false,
                        isArabic: l10n.isArabic,
                        trailing: Text(
                          currentLanguageLabel,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () => showLanguagePicker(context),
                      ),
                      for (final item in settingsItems)
                        SettingsListTile(
                          item: item,
                          isArabic: l10n.isArabic,
                          onTap: () => _showComingSoon(context, item.label, l10n),
                        ),
                    ],
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
