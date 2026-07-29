import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/history_cubit.dart';
import '../widgets/logged_meal_list_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('history_title'.tr(), style: AppTextStyles.h3(isArabic: isArabic)),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state.meals.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 48.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'history_empty'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textSecondary,
                          isArabic: isArabic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
              itemCount: state.meals.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => LoggedMealListTile(
                meal: state.meals[index],
                isArabic: isArabic,
              ),
            );
          },
        ),
      ),
    );
  }
}
