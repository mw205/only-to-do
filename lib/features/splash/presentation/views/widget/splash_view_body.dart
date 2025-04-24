import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/home/presentation/views/home_view.dart';
import 'package:only_to_do/gen/assets.gen.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    navigateToHome();
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

  void navigateToHome() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        if (!mounted) return;
        GoRouter.of(context).push(HomeView.id);
      },
    );
  }
}
