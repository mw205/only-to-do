// test/features/sleep_tracking/utils/sleep_data_utils_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/utils/sleep_data_utils.dart'; // Adjust

// Mock Widget for OptionModel

void main() {
  group('SleepDataUtils', () {
    group('calculateSleepDuration', () {
      test('calculates duration correctly for same day', () {
        final bedTime = DateTime(2024, 5, 8, 22, 0); // 10:00 PM
        final wakeUpTime = DateTime(2024, 5, 9, 6, 30); // 6:30 AM next day
        expect(SleepDataUtils.calculateSleepDuration(bedTime, wakeUpTime), 8.5);
      });

      test('calculates duration correctly crossing midnight', () {
        final bedTime = DateTime(2024, 5, 8, 23, 0); // 11:00 PM
        final wakeUpTime = DateTime(2024, 5, 9, 7, 0); // 7:00 AM next day
        expect(SleepDataUtils.calculateSleepDuration(bedTime, wakeUpTime), 8.0);
      });

      test(
          'calculates zero duration if wake time is before bed time on same day (edge case)',
          () {
        // This scenario implies waking up before going to bed on the same calendar day,
        // which usually means the wake-up is the *next* day. The logic handles this.
        final bedTime = DateTime(2024, 5, 9, 6, 0); // 6:00 AM
        final wakeUpTime = DateTime(
            2024, 5, 9, 5, 0); // 5:00 AM same day (implies next day wake up)
        // The function adds a day if wakeUp is before bedTime
        final wakeUpTimeNextDay = DateTime(2024, 5, 10, 5, 0);
        final expectedDuration =
            wakeUpTimeNextDay.difference(bedTime).inMinutes / 60.0;
        expect(SleepDataUtils.calculateSleepDuration(bedTime, wakeUpTime),
            expectedDuration); // Should be 23.0 hours
      });

      test('calculates duration correctly for exact 24 hours', () {
        final bedTime = DateTime(2024, 5, 8, 7, 0); // 7:00 AM
        final wakeUpTime = DateTime(2024, 5, 9, 7, 0); // 7:00 AM next day
        expect(
            SleepDataUtils.calculateSleepDuration(bedTime, wakeUpTime), 24.0);
      });
    });

    group('Mapping Functions', () {
      test('mapGenderStringToInt maps correctly', () {
        expect(SleepDataUtils.mapGenderStringToInt('Male'),
            SleepDataUtils.genderMale);
        expect(SleepDataUtils.mapGenderStringToInt('male'),
            SleepDataUtils.genderMale);
        expect(SleepDataUtils.mapGenderStringToInt('Female'),
            SleepDataUtils.genderFemale);
        expect(SleepDataUtils.mapGenderStringToInt('female'),
            SleepDataUtils.genderFemale);
        expect(SleepDataUtils.mapGenderStringToInt(null),
            SleepDataUtils.genderMale); // Default
        expect(SleepDataUtils.mapGenderStringToInt('Other'),
            SleepDataUtils.genderMale); // Default
      });

      test('mapBmiCategoryStringToInt maps correctly', () {
        expect(SleepDataUtils.mapBmiCategoryStringToInt('Underweight'),
            SleepDataUtils.bmiUnderweight);
        expect(SleepDataUtils.mapBmiCategoryStringToInt('Normal'),
            SleepDataUtils.bmiNormal);
        expect(SleepDataUtils.mapBmiCategoryStringToInt('Overweight'),
            SleepDataUtils.bmiOverweight);
        expect(SleepDataUtils.mapBmiCategoryStringToInt('Obese'),
            SleepDataUtils.bmiObese);
        expect(SleepDataUtils.mapBmiCategoryStringToInt(null),
            SleepDataUtils.bmiNormal); // Default
        expect(SleepDataUtils.mapBmiCategoryStringToInt('invalid'),
            SleepDataUtils.bmiNormal); // Default
      });
    });
  });
}
