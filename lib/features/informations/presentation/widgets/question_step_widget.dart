import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/features/informations/data/question_model.dart';
import 'package:only_to_do/features/informations/presentation/widgets/custom_wheel_time_picker.dart';
import 'package:only_to_do/features/informations/presentation/widgets/options_widget.dart';
import 'package:only_to_do/features/informations/presentation/widgets/question_text.dart';

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
        SizedBox(
          height: 150.h,
          width: 150.h,
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
