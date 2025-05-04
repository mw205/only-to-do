import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class OnBoardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onPressed;

  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.showButton = false,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath, height: 250.h),
          Gap(30.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 35.sp,
              fontWeight: FontWeight.bold,
              color: ColorName.purple,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(10.h),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (showButton) ...[
            Gap(60.h),
            CustomButton(
                onPressed: onPressed!, buttonText: buttonText ?? "Get Started")
          ],
        ],
      ),
    );
  }
}
