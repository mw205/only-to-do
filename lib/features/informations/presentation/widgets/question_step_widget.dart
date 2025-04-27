// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/features/informations/presentation/widgets/options_widget.dart';
import 'package:only_to_do/features/informations/presentation/widgets/progress_bar.dart';
import 'package:only_to_do/features/informations/presentation/widgets/question_text.dart';

class QuestionStepWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Map<String, dynamic> questionData;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const QuestionStepWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.questionData,
    required this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Progress Bar
        ProgressBar(currentStep: currentStep, totalSteps: totalSteps),

        // Back Button
        if (currentStep > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
              ),
            ),
          ),

        // Question Text
        QuestionText(questionData: questionData),

        SizedBox(height: 100.sp),

        // SVG Image
        questionData['svg'].svg(width: 100.0.sp, height: 100.0.sp),

        SizedBox(height: 100.sp),

        // Options
        OptionsWidget(questionData: questionData, onNext: onNext),
      ],
    );
  }
}
