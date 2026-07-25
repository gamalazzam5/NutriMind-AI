import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pill-style dot indicators for the onboarding carousel.
/// The active dot stretches into a pill; inactive dots stay round.
class OnboardingDotIndicators extends StatelessWidget {
  const OnboardingDotIndicators({
    super.key,
    required this.count,
    required this.activeIndex,
    this.inactiveColor = const Color(0xFFDCE5DA),
    this.activeColor = const Color(0xFF006D37),
  });

  final int count;
  final int activeIndex;
  final Color inactiveColor;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.only(right: index == count - 1 ? 0 : 8.w),
          width: isActive ? 32.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
