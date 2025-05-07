import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/splash/presentation/view_model/cubit/splash_cubit.dart';
import 'package:only_to_do/features/auth/presentation/pages/login_page.dart';
import 'package:only_to_do/gen/assets.gen.dart';

import '../../../../on_boarding/on_boarding_view.dart';
import '../../../../yourevent/presentation/pages/home_page.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is UserAuthenticatedState) {
          GoRouter.of(context).pushReplacement(HomePage.id);
        } else if (state is UserUnAuthenticatedState) {
          GoRouter.of(context).pushReplacement(LoginPage.id);
        } else if (state is ShowOnBoardingState) {
          GoRouter.of(context).pushReplacement(OnBoardingView.id);
        }
      },
      child: Column(
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
      ),
    );
  }
}
