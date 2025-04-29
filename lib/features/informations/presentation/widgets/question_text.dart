import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class QuestionText extends StatelessWidget {
  const QuestionText({
    super.key,
    required this.questionData,
  });

  final Map<String, dynamic> questionData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Text(
        questionData['question'],
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: ColorName.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
