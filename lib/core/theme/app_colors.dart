import 'package:flutter/material.dart';

/// NutriMind AI design-system colors.
abstract final class AppColors {
  // Primary — emerald gradient
  static const Color primaryStart = Color(0xFF2ECC71);
  static const Color primaryEnd = Color(0xFF16A085);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Deep-emerald CTA gradient — used on the Login submit button
  static const Color ctaStart = Color(0xFF006D37);
  static const Color ctaEnd = Color(0xFF2ECC71);
  static const LinearGradient ctaGradient = LinearGradient(
    colors: [ctaStart, ctaEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Emerald-teal gradient — used on the Register (Sign Up) submit button
  static const LinearGradient signUpGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary / CTA accent — coral-orange
  static const Color coral = Color(0xFFFF7A59);

  // AI / chatbot accent — soft lavender-blue
  static const Color lavender = Color(0xFF8E7CFF);

  // Background — warm off-white
  static const Color background = Color(0xFFFAFAF7);

  // Surface / text neutrals
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B6B6F);
  static const Color divider = Color(0xFFE6E6E1);

  // Macro color coding
  static const Color macroProtein = coral;
  static const Color macroCarbs = Color(0xFFF4B740);
  static const Color macroFat = Color(0xFF5DA9E9);
  static const Color macroCalories = primaryStart;

  static const Color error = Color(0xFFE74C3C);
}
