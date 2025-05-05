import 'package:flutter/material.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (currentStep + 1) / totalSteps,
          backgroundColor: ColorName.purple.withValues(alpha: 0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(ColorName.purple),
          minHeight: 4,
        ),
      ),
    );
  }
}
