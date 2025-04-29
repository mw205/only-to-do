import 'package:flutter/material.dart';
import 'package:only_to_do/features/informations/presentation/widgets/question_step_widget.dart';
import 'package:only_to_do/gen/assets.gen.dart';

class SleepQuestionsFlow extends StatefulWidget {
  const SleepQuestionsFlow({super.key});
  static const String id = "/SleepQuestionsFlow";

  @override
  State<SleepQuestionsFlow> createState() => _SleepQuestionsFlowState();
}

class _SleepQuestionsFlowState extends State<SleepQuestionsFlow> {
  int currentStep = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How much sleep do you, usually get at night?',
      'options': [
        '6 hours or less',
        '6-8 hours',
        '8-10 hours',
        '10 hours or more'
      ],
      'svg': Assets.images.logo,
    },
    {
      'question':
          'How long does it take to fall asleep after you get into bed?',
      'options': [
        'Several minutes',
        '10-15 minutes',
        '20-40 minutes',
        'Hard to fall asleep'
      ],
      'svg': Assets.images.logo,
    },
    {
      'question': 'Which habit do you have that may affect your sleep quality?',
      'svg': Assets.images.logo,
      'options': [
        'Stay up late',
        'Sleep with wet hair',
        'Heavy food before sleep',
        'Sleep with light on',
        'None of these'
      ],
    },
    {
      'question':
          'Do you ever wakeup at night and have trouble getting back to sleep?',
      'svg': Assets.images.logo,
      'options': ['Never', 'Every once a while', 'Most nights'],
    },
    {
      'question': 'Does lack of sleep affect your daily life?',
      'svg': Assets.images.logo,
      'options': ['Not at all', 'A little', 'Some what', 'Very much'],
    },
    {
      'question': 'How satisfied are you with your sleep?',
      'svg': Assets.images.logo,
      'options': [
        'Very satisfied',
        'Neutral',
        'Unsatisfied',
        'Very unsatisfied'
      ],
    },
    {
      'question': 'What time do you usually wakeup in the morning?',
      'svg': Assets.images.logo,
      'options': [],
    },
    {
      'question': 'What time do you usually go to bed?',
      'svg': Assets.images.logo,
      'options': [],
    },
  ];

  void nextStep() {
    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionData = questions[currentStep];
    return Scaffold(
      backgroundColor: const Color(0xFF011222),
      body: SafeArea(
        child: QuestionStepWidget(
          currentStep: currentStep,
          totalSteps: questions.length,
          questionData: questionData,
          onNext: nextStep,
          onBack: currentStep > 0 ? previousStep : null,
        ),
      ),
    );
  }
}
