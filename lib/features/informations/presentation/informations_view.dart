import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/features/informations/data/question_model.dart';
import 'package:only_to_do/features/informations/presentation/widgets/question_step_widget.dart';
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
      question: 'How much sleep do you, usually get at night?',
      options: [
        OptionModel(
            title: '6 hours or less', image: Assets.images.clockTime.image()),
        OptionModel(title: '6-8 hours', image: Assets.images.clockTime.image()),
        OptionModel(
            title: '8-10 hours', image: Assets.images.clockTime.image()),
        OptionModel(
            title: '10 hours or more', image: Assets.images.clockTime.image())
      ],
      photo: Assets.images.sleepingEmoji1.image(),
    ),
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
      question: 'Which habit do you have that may affect your sleep quality?',
      options: [
        OptionModel(title: 'Stay up late', image: Assets.images.moon.image()),
        OptionModel(
            title: 'Sleep with wet hair',
            image: Assets.images.waterdrops.image()),
        OptionModel(
            title: 'Heavy food before sleep',
            image: Assets.images.pizza.image()),
        OptionModel(
            title: 'Sleep with light on',
            image: Assets.images.lightPulb.image()),
        OptionModel(
            title: 'None of these', image: Assets.images.restricted.image())
      ],
      photo: Assets.images.yawningEmoji.image(),
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
      question: 'Does lack of sleep affect your daily life?',
      options: [
        OptionModel(title: 'Not at all', image: Assets.images.notAtAll.image()),
        OptionModel(title: 'A little', image: Assets.images.aLittle.image()),
        OptionModel(title: 'Some what', image: Assets.images.someWhat.image()),
        OptionModel(title: 'Very much', image: Assets.images.veryMuch.image())
      ],
      photo: Assets.images.lackOfSleep.image(),
    ),
    QuestionModel(
      question: 'How satisfied are you with your sleep?',
      options: [
        OptionModel(
            title: 'Very satisfied',
            image: Assets.images.veryUnsatisfied.image()),
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
      backgroundColor: const Color(0xFF011222),
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
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle),
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
                                Container(
                                  decoration: BoxDecoration(
                                      color: selectedAnswers[index] != null
                                          ? ColorName.purple
                                          : Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      nextStep();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
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
