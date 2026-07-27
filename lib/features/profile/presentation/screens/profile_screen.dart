import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/models/profile_stat_model.dart';
import '../../data/models/settings_item_model.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/upgrade_pro_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — ${'home_coming_soon'.tr()}')),
    );
  }

  Future<void> _confirmLogOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile_log_out'.tr()),
        content: Text('profile_log_out_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('profile_cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'profile_log_out'.tr(),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final currentLanguageLabel = (context.locale.languageCode == 'ar'
            ? 'profile_language_arabic'
            : 'profile_language_english')
        .tr();

    final stats = [
      ProfileStatModel(
        icon: Icons.local_fire_department_rounded,
        value: '12',
        label: 'profile_day_streak'.tr(),
      ),
      ProfileStatModel(
        icon: Icons.restaurant_rounded,
        value: '142',
        label: 'profile_meals_logged'.tr(),
      ),
      ProfileStatModel(
        icon: Icons.shield_rounded,
        value: '92',
        label: 'profile_avg_score'.tr(),
      ),
    ];

    final settingsItems = [
      SettingsItemModel(
        icon: Icons.track_changes_rounded,
        label: 'profile_health_goals'.tr(),
      ),
      SettingsItemModel(icon: Icons.cable_rounded, label: 'profile_integrations'.tr()),
      SettingsItemModel(
        icon: Icons.notifications_none_rounded,
        label: 'profile_notifications'.tr(),
      ),
      SettingsItemModel(icon: Icons.help_outline_rounded, label: 'profile_support'.tr()),
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
                subtitle: 'profile_wellness_enthusiast'.tr(),
                avatarAsset: 'assets/images/profile_avatar.jpg',
                streakDays: 12,
                isArabic: isArabic,
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      if (i != 0) SizedBox(width: 16.w),
                      ProfileStatCard(stat: stats[i], isArabic: isArabic),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              UpgradeProCard(
                title: 'profile_upgrade_title'.tr(),
                body: 'profile_upgrade_body'.tr(),
                ctaLabel: 'profile_join_premium'.tr(),
                isArabic: isArabic,
                onTap: () => _showComingSoon(context, 'profile_join_premium'.tr()),
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
                          label: 'profile_language'.tr(),
                        ),
                        showDivider: false,
                        isArabic: isArabic,
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
                          isArabic: isArabic,
                          onTap: () => _showComingSoon(context, item.label),
                        ),
                      SettingsListTile(
                        item: SettingsItemModel(
                          icon: Icons.logout_rounded,
                          label: 'profile_log_out'.tr(),
                        ),
                        isArabic: isArabic,
                        iconColor: AppColors.error,
                        labelColor: AppColors.error,
                        onTap: () => _confirmLogOut(context),
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
