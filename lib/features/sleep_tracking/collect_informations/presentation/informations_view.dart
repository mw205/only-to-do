import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/models/question_model.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/question_step_widget.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../../core/cubit/sleep_tracking_cubit.dart';
import '../data/models/option_model.dart';
import '../data/models/predict_sleep_quality_request_body.dart';
import '../utils/sleep_data_utils.dart'; // Import the new utils
import 'user_health_form.dart';
import 'widgets/progress_bar.dart';

class SleepQuestionsFlow extends StatefulWidget {
  const SleepQuestionsFlow({super.key});
  static const String id = "/SleepQuestionsFlow";

  @override
  State<SleepQuestionsFlow> createState() => _SleepQuestionsFlowState();
}

class _SleepQuestionsFlowState extends State<SleepQuestionsFlow> {
  late PageController controller;
  int currentStep = 0;

  // Keep your questions list as is, or refine if needed
  List<QuestionModel> questions = [
    QuestionModel(
      question: 'How long does it take to fall asleep after you get into bed?',
      options: [
        OptionModel(
            title: 'Several minutes', image: Assets.images.time.image()),
        OptionModel(title: '10-15 minutes', image: Assets.images.time.image()),
        OptionModel(title: '20-40 minutes', image: Assets.images.time.image()),
        OptionModel(
            title: 'Hard to fall asleep', image: Assets.images.time.image())
      ],
      photo: Assets.images.bed.image(),
    ),
    QuestionModel(
      question:
          'Do you ever wakeup at night and have trouble getting back to sleep?',
      options: [
        OptionModel(title: 'Never', image: Assets.images.never.image()),
        OptionModel(
            title: 'Every once a while',
            image: Assets.images.everyOnceAWhile.image()),
        OptionModel(
            title: 'Most nights', image: Assets.images.mostNights.image())
      ],
      photo: Assets.images.sleepingEmoji.image(),
    ),
    QuestionModel(
      question: 'How satisfied are you with your sleep?',
      options: [
        OptionModel(
            title: 'Very satisfied',
            image: Assets.images.verySatisfied.image()),
        OptionModel(title: 'Neutral', image: Assets.images.neutral.image()),
        OptionModel(
            title: 'Unsatisfied', image: Assets.images.unsatisfied.image()),
        OptionModel(
            title: 'Very unsatisfied',
            image: Assets.images.veryUnsatisfied.image())
      ],
      photo: Assets.images.satisfiedSleeping.image(),
    ),
    QuestionModel(
      question: 'What time do you usually wakeup in the morning?',
      isForTimePicking: true,
      photo: Assets.images.clockTime.image(), // Question 4 (index 3)
    ),
    QuestionModel(
      question: 'What time do you usually go to bed?',
      isForTimePicking: true,
      photo: Assets.images.clockTime.image(), // Question 5 (index 4)
    ),
  ];

  late List<dynamic> selectedAnswers;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    selectedAnswers = List<dynamic>.filled(questions.length, null);
  }

  void nextStep() {
    if (currentStep < questions.length - 1) {
      controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      final cubit = context.read<SleepTrackingCubit>();

      Duration? wakeUpDuration =
          (selectedAnswers.length > 3 && selectedAnswers[3] is Duration)
              ? selectedAnswers[3] as Duration
              : null;
      Duration? bedDuration =
          (selectedAnswers.length > 4 && selectedAnswers[4] is Duration)
              ? selectedAnswers[4] as Duration
              : null;

      DateTime? bedTime;
      DateTime? wakeUpTime;
      double calculatedSleepDuration = 0;

      if (bedDuration != null && wakeUpDuration != null) {
        DateTime today = DateTime.now();
        DateTime referenceDate = DateTime(today.year, today.month,
            today.day); // Use midnight today as reference

        bedTime = referenceDate.add(bedDuration);
        wakeUpTime = referenceDate.add(wakeUpDuration);

        calculatedSleepDuration =
            SleepDataUtils.calculateSleepDuration(bedTime, wakeUpTime);
      }

      // Create the initial request body
      PredictSleepQualityRequestBody initialRequestBody =
          PredictSleepQualityRequestBody(
        age: 0, // To be filled by UserHealthForm
        gender: SleepDataUtils.genderMale, // Default, to be filled
        sleepDuration:
            calculatedSleepDuration, // Use the final calculated duration
        physicalActivityLevel: 0, // Default, to be filled (minutes)
        stressLevel: SleepDataUtils.deriveInfoFromQuestions(
            selectedAnswers)['stressLevel']!,
        bmiCategory: SleepDataUtils.bmiNormal, // Default, to be filled
        heartRate: 0, // Default, to be filled
        dailySteps: 0, // Default, to be filled
        sleepDisorder: SleepDataUtils.deriveInfoFromQuestions(
            selectedAnswers)['sleepDisorder']!,
        systolicBP: 0, // Default, to be filled
        diastolicBP: 0, // Default, to be filled
      );
      cubit.updateRequestBody(initialRequestBody);
      context.push(UserHealthForm.id);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void addSelectedAnswer(int index, dynamic answer) {
    setState(() {
      selectedAnswers[index] = answer;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProgressBar(currentStep: currentStep, totalSteps: questions.length),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentStep = value;
                  });
                },
                controller: controller,
                itemCount: questions.length, // Ensure itemCount is set
                itemBuilder: (context, index) {
                  var questionData = questions[index];
                  return Column(
                    mainAxisSize: MainAxisSize
                        .min, // Important for Column within PageView
                    children: [
                      Flexible(
                        // Use Flexible to allow QuestionStepWidget to take available space
                        child: QuestionStepWidget(
                          questionData: questionData,
                          onSelectOption: (option) {
                            addSelectedAnswer(index, option);
                            nextStep();
                          },
                          onSelectTime: (duration) {
                            addSelectedAnswer(index, duration);
                          },
                        ),
                      ),
                      if (index >= 0)
                        Padding(
                          padding: EdgeInsets.all(16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (index > 0)
                                Container(
                                  decoration: const BoxDecoration(
                                    color: ColorName.purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: previousStep,
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              else
                                const Gap(48),
                              if (questionData.isForTimePicking ||
                                  index == questions.length - 1)
                                AnimatedOpacity(
                                  opacity: (questionData.isForTimePicking &&
                                          selectedAnswers[index] == null)
                                      ? 0.5
                                      : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (questionData.isForTimePicking &&
                                                selectedAnswers[index] == null)
                                            ? Colors.grey // Disabled appearance
                                            : ColorName.purple,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: (questionData
                                                  .isForTimePicking &&
                                              selectedAnswers[index] == null)
                                          ? null
                                          : nextStep,
                                      icon: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              else if (!questionData.isForTimePicking &&
                                  index < questions.length - 1)
                                const Gap(48),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
