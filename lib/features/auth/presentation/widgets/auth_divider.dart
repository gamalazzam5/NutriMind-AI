import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFBBCBBB), thickness: 1, height: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            label,
            style: AppTextStyles.caption(color: const Color(0xFF6C7B6D)).copyWith(letterSpacing: 0.6),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFBBCBBB), thickness: 1, height: 1)),
      ],
    );
  }
}
