// test/features/sleep_tracking/data/models/predict_sleep_quality_request_body_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/models/predict_sleep_quality_request_body.dart'; // Adjust import path

void main() {
  group('PredictSleepQualityRequestBody', () {
    // Sample data for testing
    final tRequestBody = PredictSleepQualityRequestBody(
      age: 30,
      gender: 1, // Female
      sleepDuration: 7.5,
      physicalActivityLevel: 60.0,
      stressLevel: 4,
      bmiCategory: 1, // Normal
      heartRate: 65,
      dailySteps: 8000,
      sleepDisorder: 0, // None
      systolicBP: 120,
      diastolicBP: 80,
    );

    final Map<String, dynamic> tJsonMap = {
      'Age': 30,
      'Gender': 1,
      'Sleep_Duration': 7.5,
      'Physical_Activity_Level': 60.0,
      'Stress_Level': 4,
      'BMI_Category': 1,
      'Heart_Rate': 65,
      'Daily_Steps': 8000,
      'Sleep_Disorder': 0,
      'Systolic_BP': 120,
      'Diastolic_BP': 80,
    };

    test('fromJson should return a valid model from JSON', () {
      // Act
      final result = PredictSleepQualityRequestBody.fromJson(tJsonMap);
      // Assert
      expect(result, isA<PredictSleepQualityRequestBody>());
      expect(result.age, tRequestBody.age);
      expect(result.gender, tRequestBody.gender);
      expect(result.sleepDuration, tRequestBody.sleepDuration);
      expect(result.physicalActivityLevel, tRequestBody.physicalActivityLevel);
      expect(result.stressLevel, tRequestBody.stressLevel);
      expect(result.bmiCategory, tRequestBody.bmiCategory);
      expect(result.heartRate, tRequestBody.heartRate);
      expect(result.dailySteps, tRequestBody.dailySteps);
      expect(result.sleepDisorder, tRequestBody.sleepDisorder);
      expect(result.systolicBP, tRequestBody.systolicBP);
      expect(result.diastolicBP, tRequestBody.diastolicBP);
      // Using toString comparison as HiveObject might affect direct equality
      expect(result.toString(), tRequestBody.toString());
    });

    test('toJson should return a valid JSON map from model', () {
      // Act
      final result = tRequestBody.toJson();
      // Assert
      expect(result, equals(tJsonMap));
    });

    test('copyWith should create a new instance with updated fields', () {
      // Act
      final updatedBody = tRequestBody.copyWith(
        stressLevel: 8,
        dailySteps: 10000,
      );

      // Assert
      expect(updatedBody.stressLevel, 8);
      expect(updatedBody.dailySteps, 10000);
      // Ensure other fields remain the same
      expect(updatedBody.age, tRequestBody.age);
      expect(updatedBody.gender, tRequestBody.gender);
      expect(updatedBody.sleepDuration, tRequestBody.sleepDuration);
      expect(updatedBody.sleepDisorder, tRequestBody.sleepDisorder);
    });

    test('toString() should return a correct string representation', () {
      final expectedString =
          'PredictSleepQualityRequestBody(Age: 30, Gender: 1, Sleep_Duration: 7.5, Physical_Activity_Level: 60.0, Stress_Level: 4, BMI_Category: 1, Heart_Rate: 65, Daily_Steps: 8000, Sleep_Disorder: 0, Systolic_BP: 120, Diastolic_BP: 80)';
      expect(tRequestBody.toString(), expectedString);
    });
  });
}
