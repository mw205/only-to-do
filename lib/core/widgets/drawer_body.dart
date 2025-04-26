import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/core/styles/app_box_decorations.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.close,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: AppBoxDecorations.pomodoroTaskDecoration,
                  child: Row(
                    children: [
                      Assets.images.tag.svg(),
                      Text(
                        "Manage",
                        style: AppTextStyles.kWhite12W600,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: Colors.black,
            ),
            title: const Text('Inbox '),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.wb_sunny_outlined,
              color: Colors.black,
            ),
            title: const Text('Today'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_today_outlined,
              color: Colors.black,
            ),
            title: const Text('Upcoming'),
            onTap: () {},
          ),
          Divider(
            color: ColorName.grey1,
          ),
          Row(
            children: [
              Icon(Icons.circle, color: Colors.red),
              Text("Sports"),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Icon(Icons.circle, color: ColorName.yellow),
              Text("Work"),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Icon(Icons.circle, color: ColorName.green),
              Text("Fun"),
            ],
          ),
          Gap(15.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: AppBoxDecorations.pomodoroTaskDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "Add folder",
                    style: AppTextStyles.kWhite12W600,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: ColorName.grey1,
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            title: const Text('Settings'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
// hello
