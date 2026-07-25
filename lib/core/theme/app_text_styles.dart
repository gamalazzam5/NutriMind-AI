import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography — Poppins for English, Almarai for Arabic.
/// Pass [isArabic] (derived from `Localizations.localeOf(context).languageCode == 'ar'`)
/// to select the correct family; defaults to Poppins.
abstract final class AppTextStyles {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
    bool isArabic = false,
    double? height,
  }) {
    final builder = isArabic ? GoogleFonts.almarai : GoogleFonts.poppins;
    return builder(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle h1({bool isArabic = false, Color color = AppColors.textPrimary}) =>
      _base(fontSize: 28, fontWeight: FontWeight.w600, color: color, isArabic: isArabic);

  static TextStyle h2({bool isArabic = false, Color color = AppColors.textPrimary}) =>
      _base(fontSize: 22, fontWeight: FontWeight.w600, color: color, isArabic: isArabic);

  static TextStyle h3({bool isArabic = false, Color color = AppColors.textPrimary}) =>
      _base(fontSize: 18, fontWeight: FontWeight.w600, color: color, isArabic: isArabic);

  static TextStyle bodyLarge({bool isArabic = false, Color color = AppColors.textPrimary}) =>
      _base(fontSize: 16, fontWeight: FontWeight.w400, color: color, isArabic: isArabic, height: 1.4);

  static TextStyle bodyMedium({bool isArabic = false, Color color = AppColors.textPrimary}) =>
      _base(fontSize: 14, fontWeight: FontWeight.w400, color: color, isArabic: isArabic, height: 1.4);

  static TextStyle bodySmall({bool isArabic = false, Color color = AppColors.textSecondary}) =>
      _base(fontSize: 12, fontWeight: FontWeight.w400, color: color, isArabic: isArabic);

  static TextStyle button({bool isArabic = false, Color color = Colors.white}) =>
      _base(fontSize: 16, fontWeight: FontWeight.w600, color: color, isArabic: isArabic);

  static TextStyle caption({bool isArabic = false, Color color = AppColors.textSecondary}) =>
      _base(fontSize: 11, fontWeight: FontWeight.w500, color: color, isArabic: isArabic);
}
