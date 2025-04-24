import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class InfoDetails extends StatefulWidget {
  const InfoDetails({super.key});

  @override
  State<InfoDetails> createState() => _InfoDeataliesState();
}

bool isHabit = false;

class _InfoDeataliesState extends State<InfoDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Add attachment',
                style: AppTextStyles.font18Black1Medium,
              ),
              SizedBox(
                width: 20.sp,
              ),
              Assets.images.location.svg(
                width: 24.w,
              ),
            ],
          ),
          SizedBox(
            height: 20.sp,
          ),
          Row(
            children: [
              Text(
                'Add location',
                style: AppTextStyles.font18Black1Medium,
              ),
              SizedBox(
                width: 20.sp,
              ),
              Assets.images.location.svg(
                width: 24.w,
              ),
            ],
          ),
          SizedBox(
            height: 20.sp,
          ),
          Row(
            children: [
              Text(
                'Make habit',
                style: AppTextStyles.font18Black1Medium,
              ),
              SizedBox(
                width: 20.sp,
              ),
              Switch.adaptive(
                value: isHabit,
                onChanged: (bool value) {
                  setState(() {
                    isHabit = value;
                  });
                },
                activeColor: ColorName.purple,
              ),
            ],
          )
        ],
      ),
    );
  }
}
