import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/core/styles/app_box_decorations.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class PomodoroTasksSection extends StatelessWidget {
  const PomodoroTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        spacing: 10.h,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 25.h),
            child: Column(
              children: [
                Text(
                  "#1",
                  style: AppTextStyles.kBlack16W600,
                ),
                Text(
                  "#Drafting",
                  style: AppTextStyles.kBlack16W600,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tasks",
                  style: AppTextStyles.kBlack16W600,
                ),
                Assets.images.thList.svg()
              ],
            ),
          ),
          Divider(
            color: ColorName.black,
          ),
          Column(
            children: [
              Container(
                decoration: AppBoxDecorations.pomodoroTaskDecoration,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: ColorName.white,
                              size: 24.sp,
                            ),
                            Gap(15.w),
                            Text(
                              "BrainStorming",
                              style: AppTextStyles.kWhite16W600,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "1/2",
                              style: TextStyle(
                                color: ColorName.white.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                              ),
                            ),
                            Gap(20.w),
                            Assets.images.thList.svg(
                              colorFilter: ColorFilter.mode(
                                ColorName.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 16.h),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        elevation: 2,
                        shadowColor: ColorName.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "on the subjective passing of time.",
                            style: AppTextStyles.kBlack16W600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
