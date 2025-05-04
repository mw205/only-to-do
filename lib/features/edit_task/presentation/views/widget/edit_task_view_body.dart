import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/bottom_action_bar.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/descriotion_field.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/repeat_every_widget.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/drawer_body.dart';

class EditTaskViewBody extends StatefulWidget {
  const EditTaskViewBody({super.key});

  @override
  State<EditTaskViewBody> createState() => _EditTaskViewBodyState();
}

class _EditTaskViewBodyState extends State<EditTaskViewBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerBody(),
      ),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: 'Edit Task', scaffoldKey: _scaffoldKey),
      body: ListView(
        children: [
          CustomTextField(
            height: 123.sp,
            width: 331.sp,
            hintText: 'Add description..',
          ),
          // PrioritySelector(),
          SizedBox(
            height: 20.h,
          ),
          RepeatEveryWidget(),
          SizedBox(
            height: 20.h,
          ),
          // InfoDetails(),
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
