import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/core/styles/app_box_decorations.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.buttonText,
    this.child
  });

  final VoidCallback? onPressed;
  final String? buttonText;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.h,
        width: 150.w,
        decoration: AppBoxDecorations.purpleButtonDecoration,
        child: Center(
          child: child ??
              Text(
                buttonText!,
                style: TextStyle(
                  color: ColorName.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
        ),
      ),
    );
  }
}
