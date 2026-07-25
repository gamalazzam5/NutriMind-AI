import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../data/models/onboarding_page_model.dart';
import 'onboarding_dot_indicators.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
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
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h1(color: const Color(0xFF161D17)),
          ),
          SizedBox(height: 16.h),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(color: const Color(0xFF3D4A3E)),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OnboardingDotIndicators(count: dotCount, activeIndex: dotIndex),
              GradientButton(
                label: page.ctaLabel,
                onPressed: onNext,
                icon: Icons.arrow_forward_rounded,
                iconTrailing: true,
                fullWidth: false,
                showShadow: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
