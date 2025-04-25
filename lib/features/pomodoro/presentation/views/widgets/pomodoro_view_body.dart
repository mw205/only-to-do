import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/features/pomodoro/presentation/views/widgets/pomodor_time_indicator.dart';
import 'package:only_to_do/features/pomodoro/presentation/views/widgets/pomodoro_tasks_section.dart';

class PomodoroViewBody extends StatelessWidget {
  const PomodoroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Gap(50.h),
        PomodorTimeIndicator(),
        PomodoroTasksSection(),
      ],
    );
  }
}
