import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// "Don't have an account? Create account" style footer row.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefixText,
    required this.actionText,
    required this.onTap,
  });

  final String prefixText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prefixText, style: AppTextStyles.bodyLarge(color: const Color(0xFF3D4A3E))),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: AppTextStyles.bodyMedium(color: const Color(0xFF006D37))
                  .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.14),
            ),
          ),
        ],
      ),
    );
  }
}
