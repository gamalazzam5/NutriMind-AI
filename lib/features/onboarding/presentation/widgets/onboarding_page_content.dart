import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_radius.dart';
import '../../data/models/onboarding_page_model.dart';
import 'onboarding_controls.dart';

/// Same structure on every page: a fixed-height, full-width illustration on
/// top and an identical card below it, so the heading/body/dots/CTA always
/// land in the same place as the user swipes between pages.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.page,
    required this.dotIndex,
    required this.dotCount,
    required this.onNext,
  });

  final OnboardingPageModel page;
  final int dotIndex;
  final int dotCount;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 76.h, 24.w, 24.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Image.asset(
                page.imageAsset,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(48.r),
                topRight: Radius.circular(48.r),
              ),
            ),
            child: OnboardingControls(
              page: page,
              dotIndex: dotIndex,
              dotCount: dotCount,
              onNext: onNext,
            ),
          ),
        ),
      ],
    );
  }
}
