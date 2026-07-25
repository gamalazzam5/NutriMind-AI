import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Corner radii used across cards, buttons, and sheets.
abstract final class AppRadius {
  static double get sm => 12.r;
  static double get md => 16.r;
  static double get lg => 20.r;
  static double get xl => 24.r;
  static const double pill = 999;
}
