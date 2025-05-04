import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/auth/presentation/pages/login_page.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/custom_button.dart';
import '../../auth/presentation/pages/signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = "/welcome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.logo.svg(height: 170.h),
              Gap(80.h),
              CustomButton(
                buttonText: "Register",
                onPressed: () {
                  disableShowOnBoarding();
                  context.pushReplacement(SignupPage.id);
                },
              ),
              Gap(20.h),
              CustomButton(
                buttonText: "Login",
                onPressed: () {
                  disableShowOnBoarding();
                  context.pushReplacement(LoginPage.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void disableShowOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showOnBoarding', true);
  }
}
