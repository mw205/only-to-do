import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/question_model.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/user_health_form.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/question_step_widget.dart';
import 'package:only_to_do/gen/assets.gen.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../data/option_model.dart';
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
      photo: Assets.images.clockTime.image(),
    ),
    QuestionModel(
      question: 'What time do you usually go to bed?',
      isForTimePicking: true,
      photo: Assets.images.clockTime.image(),
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
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      controller.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void addSelectedAnswer(int index, dynamic answer) {
    setState(() {
      // Ensure list is long enough (should be due to initState)
      if (selectedAnswers.length <= index) {
        selectedAnswers.length = questions.length;
      }

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
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentStep = value;
                  });
                },
                controller: controller,
                itemBuilder: (context, index) {
                  var questionData = questions[index];
                  bool isForTimePicking = questionData.isForTimePicking;
                  final dynamic currentAnswer = selectedAnswers[index];
                  Duration? initialDuration;
                  if (currentAnswer is Duration) {
                    initialDuration = currentAnswer;
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: QuestionStepWidget(
                          questionData: questionData,
                          onSelectOption: (option) {
                            addSelectedAnswer(index, option);
                            nextStep();
                            // print(option);
                          },
                          onSelectTime: (duration) {
                            addSelectedAnswer(index, duration);
                          },
                        ),
                      ),
                      if (index > 0)
                        Padding(
                          padding: EdgeInsets.all(16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorName.purple,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    previousStep();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (isForTimePicking)
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.linear,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: selectedAnswers[index] != null
                                            ? ColorName.purple
                                            : Colors.white
                                                .withValues(alpha: 0.2),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        if (index == questions.length - 1) {
                                          context.push(UserHealthForm.id);
                                          return;
                                        }
                                        nextStep();
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!isForTimePicking) const SizedBox(width: 48),
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
