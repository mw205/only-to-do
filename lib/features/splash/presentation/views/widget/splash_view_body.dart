import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:only_to_do/features/yourevent/presentation/pages/auth/login_page.dart';
import 'package:only_to_do/gen/assets.gen.dart';

import '../../../../yourevent/presentation/pages/home_page.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    checkAuthAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Assets.images.logo
            .svg(
              width: 150.w,
            )
            .animate()
            .slideX(duration: Duration(seconds: 1), begin: -1, end: 0)
            .fadeIn(
              duration: Duration(milliseconds: 1500),
            ),
      ],
    );
  }

  void checkAuthAndNavigate() {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        if (!mounted) return;

        // Check if user is logged in with Firebase
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // User is logged in, navigate to home
          GoRouter.of(context).push(HomePage.id);
        } else {
          // User is not logged in, navigate to login page
          GoRouter.of(context).push(LoginPage.id);
        }
      },
    );
  }
}
