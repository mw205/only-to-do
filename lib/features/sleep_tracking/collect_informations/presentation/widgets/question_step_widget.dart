import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/question_model.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/custom_wheel_time_picker.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/options_widget.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/question_text.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../../data/option_model.dart';

class QuestionStepWidget extends StatelessWidget {
  final QuestionModel questionData;

  const QuestionStepWidget(
      {super.key,
      required this.questionData,
      required this.onSelectOption,
      this.onSelectTime});
  final void Function(OptionModel) onSelectOption;
  final void Function(Duration duration)? onSelectTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Question Text
        QuestionText(question: questionData.question),
        Gap(80.h),
        Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorName.purple.withValues(alpha: 0.1)),
          height: 200.h,
          width: 200.h,
          child: questionData.photo,
        ),
        Gap(80.h),
        // Options
        questionData.isForTimePicking
            ? CustomWheelTimePicker(
                onSelectTime: onSelectTime,
              )
            : OptionsWidget(
                options: questionData.options!,
                onSelectOption: onSelectOption,
              ),
      ],
    );
  }
}
