import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Text field used across Login/Register. Supports two visual variants
/// driven by [fillColor]: white+shadow (Login) or flat gray (Register).
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.label,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.keyboardType,
    this.fillColor,
    this.showShadow = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? label;
  final bool obscureText;
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final bool showShadow;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodyMedium(color: const Color(0xFF3D4A3E))
                .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.14),
          ),
          SizedBox(height: 4.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: widget.fillColor ?? Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: widget.showShadow
                ? [
                    BoxShadow(
                      color: AppColors.primaryStart.withValues(alpha: 0.08),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyLarge(color: const Color(0xFFBBCBBB)),
              prefixIcon: Icon(widget.icon, size: 20.sp, color: const Color(0xFF6B7280)),
              suffixIcon: widget.showObscureToggle
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20.sp,
                        color: const Color(0xFF6B7280),
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }
}
