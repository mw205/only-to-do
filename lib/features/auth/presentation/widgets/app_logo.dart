// lib/presentation/pages/auth/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.images.logo.svg(width: 150.w);
  }
}
