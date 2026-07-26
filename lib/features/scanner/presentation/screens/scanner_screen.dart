import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/scanner_cubit.dart';
import '../cubit/scanner_state.dart';
import '../widgets/scan_result_sheet.dart';
import '../widgets/scanner_frame_overlay.dart';
import '../widgets/scanner_idle_view.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScannerCubit>(),
      child: const _ScannerView(),
    );
  }
}

class _ScannerView extends StatelessWidget {
  const _ScannerView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<ScannerCubit, ScannerState>(
        listener: (context, state) {
          if (state is ScannerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.t(state.messageKey))),
            );
          }
        },
        builder: (context, state) {
          if (state is ScannerIdle || state is ScannerError) {
            return ScannerIdleView(
              onTakePhoto: () => context.read<ScannerCubit>().captureFromCamera(),
              onChooseFromGallery: () =>
                  context.read<ScannerCubit>().captureFromGallery(),
            );
          }

          final imagePath = switch (state) {
            ScannerScanning(:final imagePath) => imagePath,
            ScannerResultReady(:final imagePath) => imagePath,
            _ => null,
          };

          return Stack(
            fit: StackFit.expand,
            children: [
              if (imagePath != null)
                Opacity(
                  opacity: 0.8,
                  child: Image.file(File(imagePath), fit: BoxFit.cover),
                ),
              SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _RoundIconButton(
                            icon: Icons.close_rounded,
                            onTap: () => context.read<ScannerCubit>().reset(),
                          ),
                          if (state is ScannerScanning)
                            _StatusPill(label: l10n.t('scanner_scanning')),
                          _RoundIconButton(icon: Icons.bolt_rounded, onTap: () {}),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: const ScannerFrameOverlay(),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      l10n.t('scanner_center_food'),
                      style: AppTextStyles.bodyLarge(
                        color: Colors.white.withValues(alpha: 0.8),
                        isArabic: l10n.isArabic,
                      ),
                    ),
                    if (state is ScannerScanning)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: SizedBox(
                          width: 28.r,
                          height: 28.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(AppColors.primaryStart),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state is ScannerResultReady)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                    ),
                    child: SingleChildScrollView(
                      child: ScanResultSheet(
                        result: state.result,
                        onLog: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.t('scanner_meal_logged'))),
                          );
                          context.read<ScannerCubit>().reset();
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppTextStyles.bodyLarge(color: Colors.white)),
    );
  }
}
