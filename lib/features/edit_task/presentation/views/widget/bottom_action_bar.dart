import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';
import 'package:only_to_do/gen/assets.gen.dart';

class BottomActionsBar extends StatelessWidget {
  const BottomActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.calendar.svg(
                  width: 24.w,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
              Gap(12),
              Assets.images.clock.svg(
                width: 24.w,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              Gap(12),
              Assets.images.tag.svg(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 24.w,
              ),
              Gap(12),
              Assets.images.sleepScore.svg(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 24.w,
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    minimumSize: const Size(0, 40),
                  ),
                  icon: Icon(Icons.more_horiz,
                      color: Colors.deepPurple, size: 20.w),
                  label: const Text(
                    'Details',
                    style: TextStyle(color: Colors.deepPurple),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(8.w),
                CustomButton(onPressed: () {}, buttonText: 'Save task'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
