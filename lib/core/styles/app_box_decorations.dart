import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/colors.gen.dart';

class AppBoxDecorations {
  static BoxDecoration buttonDecoration = BoxDecoration(
    color: ColorName.white,
    borderRadius: BorderRadius.circular(5.r),
  );
  static BoxDecoration pomodoroTaskDecoration = BoxDecoration(
    color: ColorName.purple,
    borderRadius: BorderRadius.circular(10.r),
  );
  static BoxDecoration purpleButtonDecoration = BoxDecoration(
    color: ColorName.purple,
    borderRadius: BorderRadius.circular(10.r),
  );
}
