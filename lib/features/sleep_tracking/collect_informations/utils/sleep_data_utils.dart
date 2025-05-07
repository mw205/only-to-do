import 'package:flutter/material.dart';

import '../data/models/option_model.dart';

class SleepDataUtils {
  // --- Mappings for API ---
  static const int genderMale = 0;
  static const int genderFemale = 1;

  static const int bmiUnderweight = 0;
  static const int bmiNormal = 1;
  static const int bmiOverweight = 2;
  static const int bmiObese = 3;

  static const int sleepDisorderNone = 0;
  static const int sleepDisorderInsomnia = 1;
  static const int sleepDisorderApnea = 2;
  static double calculateSleepDuration(DateTime bedTime, DateTime wakeUpTime) {
    if (wakeUpTime.isBefore(bedTime)) {
      wakeUpTime = wakeUpTime.add(const Duration(days: 1));
    }
    return wakeUpTime.difference(bedTime).inMinutes / 60.0; // Convert to hours
  }

  static Map<String, int> deriveInfoFromQuestions(List<dynamic> answers) {
    int defaultStressScore = 5; //scale should be from 1 to 10
    int defaultSleepDisorder = sleepDisorderNone;

    if (answers.length < 3) {
      return {
        'stressLevel': defaultStressScore,
        'sleepDisorder': defaultSleepDisorder
      };
    }

    OptionModel? answerQ1 = (answers.isNotEmpty && answers[0] is OptionModel)
        ? answers[0] as OptionModel
        : null;
    OptionModel? answerQ2 = (answers.length > 1 && answers[1] is OptionModel)
        ? answers[1] as OptionModel
        : null;
    OptionModel? answerQ3 = (answers.length > 2 && answers[2] is OptionModel)
        ? answers[2] as OptionModel
        : null;

    // --- Sleep Disorder Logic ---
    int derivedSleepDisorder = defaultSleepDisorder;
    if (answerQ2 != null) {
      switch (answerQ2.title) {
        case 'Never':
          derivedSleepDisorder = sleepDisorderNone;
          break;
        case 'Every once a while':
          derivedSleepDisorder =
              sleepDisorderNone; // Or a specific code if your model supports "mild"
          break;
        case 'Most nights':
          derivedSleepDisorder = sleepDisorderInsomnia;
          break;
      }
    }

    // --- Stress Level Logic (1-10 scale) ---
    int scoreQ1 = 2; // Default for Q1
    if (answerQ1 != null) {
      switch (answerQ1.title) {
        case 'Several minutes':
          scoreQ1 = 0;
          break;
        case '10-15 minutes':
          scoreQ1 = 1;
          break;
        case '20-40 minutes':
          scoreQ1 = 3;
          break;
        case 'Hard to fall asleep':
          scoreQ1 = 5;
          break;
      }
    }

    int scoreQ2StressContribution = 2; // Default for Q2's stress impact
    if (answerQ2 != null) {
      switch (answerQ2.title) {
        case 'Never':
          scoreQ2StressContribution = 0;
          break;
        case 'Every once a while':
          scoreQ2StressContribution = 2;
          break;
        case 'Most nights':
          scoreQ2StressContribution = 4;
          break;
      }
    }

    int scoreQ3 = 3; // Default for Q3
    if (answerQ3 != null) {
      switch (answerQ3.title) {
        case 'Very satisfied':
          scoreQ3 = 0;
          break;
        case 'Neutral':
          scoreQ3 = 2;
          break;
        case 'Unsatisfied':
          scoreQ3 = 4;
          break;
        case 'Very unsatisfied':
          scoreQ3 = 6;
          break;
      }
    }

    int rawTotalStressScore =
        scoreQ1 + scoreQ2StressContribution + scoreQ3; // Max 5+4+6 = 15

    // Scale to 1-10 for StressLevel: StressLevel = 1 + (rawTotalStressScore * 0.6)
    int finalStressLevel = (1 + (rawTotalStressScore * 0.6)).round().toInt();

    return {
      'stressLevel': finalStressLevel.clamp(1, 10),
      'sleepDisorder': derivedSleepDisorder,
    };
  }

  static int mapGenderStringToInt(String? genderString) {
    if (genderString?.toLowerCase() == 'male') return genderMale;
    if (genderString?.toLowerCase() == 'female') return genderFemale;
    return genderMale; // Default or handle error
  }

  static int mapBmiCategoryStringToInt(String? bmiCategoryString) {
    switch (bmiCategoryString?.toLowerCase()) {
      case 'underweight':
        return bmiUnderweight;
      case 'normal':
        return bmiNormal;
      case 'overweight':
        return bmiOverweight;
      case 'obese':
        return bmiObese;
      default:
        return bmiNormal; // Default or handle error
    }
  }

  Duration timeOfDayToDuration(TimeOfDay time) {
    return Duration(hours: time.hour, minutes: time.minute);
  }
}
