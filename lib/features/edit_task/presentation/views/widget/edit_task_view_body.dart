import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/core/widgets/custom_app_bar.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/Priority_selector.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/bottom_action_bar.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/descriotion_field.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/Info_details.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/repeat_every_widget.dart';

class EditTaskViewBody extends StatelessWidget {
  const EditTaskViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Task'),
      body: ListView(
        children: [
          CustomTextField(
            height: 123.sp,
            width: 331.sp,
            hintText: 'Add description..',
          ),
          PrioritySelector(),
          SizedBox(
            height: 20.h,
          ),
          RepeatEveryWidget(),
          SizedBox(
            height: 20.h,
          ),
          InfoDetails(),
          CustomTextField(
              hintText: 'Add tags like exercise, work, etc.',
              height: 47.h,
              width: 313.w),
        ],
      ),
      bottomNavigationBar: BottomActionsBar(),
    );
  }
}
