import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/core/styles/app_box_decorations.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class PomodorTimeIndicator extends StatelessWidget {
  const PomodorTimeIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 21.w),
      child: Center(
        child: DefaultTabController(
          length: 3,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: ColorName.purple,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: TabBar(
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      physics: NeverScrollableScrollPhysics(),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      indicatorPadding: EdgeInsets.symmetric(horizontal: -15.w),
                      labelStyle: AppTextStyles.kPurple12W600,
                      unselectedLabelStyle: AppTextStyles.kWhite12W600,
                      indicator: AppBoxDecorations.buttonDecoration,
                      tabs: [
                        Tab(
                          text: "Pomodoro",
                        ),
                        Tab(
                          text: "Long Break",
                        ),
                        Tab(
                          text: "Short Break",
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Text(
                          "23:42",
                          style: AppTextStyles.kWhite72W700,
                        ),
                      ),
                      Center(
                        child: Text(
                          "23:42",
                          style: AppTextStyles.kWhite72W700,
                        ),
                      ),
                      Center(
                        child: Text(
                          "23:42",
                          style: AppTextStyles.kWhite72W700,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.h),
                        decoration: AppBoxDecorations.buttonDecoration,
                        child: Center(
                          child: Text(
                            "Pause".toUpperCase(),
                            style: AppTextStyles.kPurple15W600,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_next,
                          size: 35.sp,
                          color: ColorName.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
