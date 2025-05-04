import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/on_boarding/widgets/on_boarding_page.dart';
import 'package:only_to_do/features/on_boarding/widgets/welcome_screen.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});
  static String id = "/on_boarding";
  @override
  // ignore: library_private_types_in_public_api
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                OnBoardingPage(
                  imagePath: Assets.images.onboarding1.path,
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                ),
                OnBoardingPage(
                  imagePath: Assets.images.onboarding2.path,
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                ),
                OnBoardingPage(
                  imagePath: Assets.images.onboarding3.path,
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                  showButton: true,
                  buttonText: 'Get Started',
                  onPressed: () {
                    context.pushReplacement(WelcomeScreen.id);
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => buildDot(index, context),
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8.h,
      width: _currentPage == index ? 24.w : 8.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: _currentPage == index ? ColorName.purple : Colors.grey,
      ),
    );
  }
}
