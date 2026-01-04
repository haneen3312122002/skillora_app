import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  static final double spaceXS = 4.h;
  static final double homeContainerH = 340.h;
  static final double homeContainerW = 240.h;
  static final double spaceXXS = 5.h;

  static final double spaceSM = 8.h;

  static final double spaceMD = 16.h;

  static final double spaceLG = 24.h;

  static final double spaceXL = 32.h;

  static final double spaceXXL = 48.h;

  static final double screenHorizontal = 5.w;

  static final double screenVertical = 5.h;

  static final double sectionPadding = 1.h;

  static final double sectionSpacing = 1.h;

  static final double buttonTextGap = 12.h;

  static final double labelFieldGap = 6.h;
  // ✅ NEW (استخدميهم بالشاشات اللي بدها تصحيح)
  static double x(double v) => v.w; // أفقي
  static double y(double v) => v.h; // عمودي
  static double r(double v) => v.r;
}
