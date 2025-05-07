// test/features/sleep_tracking/cubit/sleep_tracking_cubit_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:only_to_do/core/network/api_error_handler.dart'; // Adjust import path
import 'package:only_to_do/core/network/api_result.dart'; // Adjust import path
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/models/predict_sleep_quality_request_body.dart'; // Adjust
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/repository/sleep_tracking_repository.dart'; // Adjust
import 'package:only_to_do/features/sleep_tracking/core/cubit/sleep_tracking_cubit.dart'; // Adjust

class MockSleepTrackingRepository extends Mock
    implements SleepTrackingRepository {}

void main() {
  late SleepTrackingCubit sleepTrackingCubit;
  late MockSleepTrackingRepository mockSleepTrackingRepository;

  // Sample request body
  final tRequestBody = PredictSleepQualityRequestBody(
      age: 30,
      gender: 1,
      sleepDuration: 7.0,
      physicalActivityLevel: 50,
      stressLevel: 5,
      bmiCategory: 1,
      heartRate: 70,
      dailySteps: 7000,
      sleepDisorder: 0,
      systolicBP: 125,
      diastolicBP: 82);
  final tRequestBodyUpdated = tRequestBody.copyWith(stressLevel: 8);
  const tSuccessResult = 0.85; // Example success value (e.g., 85%)
  final tError = ApiErrorHandler(code: 500, message: 'Prediction failed');
  final tFailureResult = ApiResult<double>.failure(tError);
  final tSuccessApiResult = ApiResult<double>.success(tSuccessResult);

  // Register fallback value for PredictSleepQualityRequestBody
  setUpAll(() {
    registerFallbackValue(PredictSleepQualityRequestBody(
        age: 0,
        gender: 0,
        sleepDuration: 0,
        physicalActivityLevel: 0,
        stressLevel: 0,
        bmiCategory: 0,
        heartRate: 0,
        dailySteps: 0,
        sleepDisorder: 0,
        systolicBP: 0,
        diastolicBP: 0));
  });

  setUp(() {
    mockSleepTrackingRepository = MockSleepTrackingRepository();
    sleepTrackingCubit = SleepTrackingCubit(mockSleepTrackingRepository);
  });

  tearDown(() {
    sleepTrackingCubit.close();
  });

  group('SleepTrackingCubit', () {
    test('initial state is SleepTrackingState.initial()', () {
      expect(
          sleepTrackingCubit.state, equals(const SleepTrackingState.initial()));
      expect(sleepTrackingCubit.requestBody, isNull);
    });

    test('updateRequestBody updates internal state and emits dataUpdated', () {
      // Act
      sleepTrackingCubit.updateRequestBody(tRequestBody);
      // Assert
      expect(sleepTrackingCubit.requestBody, equals(tRequestBody));
      expect(sleepTrackingCubit.state,
          equals(SleepTrackingState.dataUpdated(data: tRequestBody)));
    });

    test('resetSleepTrackingData clears internal state and emits initial', () {
      // Arrange: Set some initial data
      sleepTrackingCubit.updateRequestBody(tRequestBody);
      expect(sleepTrackingCubit.requestBody, isNotNull);
      expect(
          sleepTrackingCubit.state, isNot(const SleepTrackingState.initial()));

      // Act
      sleepTrackingCubit.resetSleepTrackingData();

      // Assert
      expect(sleepTrackingCubit.requestBody, isNull);
      expect(
          sleepTrackingCubit.state, equals(const SleepTrackingState.initial()));
    });

    group('predictSleepQuality', () {
      blocTest<SleepTrackingCubit, SleepTrackingState>(
        'emits [loading, success] when prediction is successful',
        setUp: () {
          // Set the request body first
          sleepTrackingCubit.updateRequestBody(tRequestBody);
          when(() =>
                  mockSleepTrackingRepository.predictSleepQuality(tRequestBody))
              .thenAnswer((_) async => tSuccessApiResult);
        },
        build: () => sleepTrackingCubit,
        act: (cubit) => cubit.predictSleepQuality(),
        expect: () => [
          // The state before prediction starts should be dataUpdated
          const SleepTrackingState.loading(),
          SleepTrackingState.success(result: tSuccessResult),
        ],
        verify: (_) {
          verify(() =>
                  mockSleepTrackingRepository.predictSleepQuality(tRequestBody))
              .called(1);
        },
      );

      blocTest<SleepTrackingCubit, SleepTrackingState>(
        'emits [loading, failure] when prediction fails',
        setUp: () {
          sleepTrackingCubit.updateRequestBody(tRequestBody);
          when(() =>
                  mockSleepTrackingRepository.predictSleepQuality(tRequestBody))
              .thenAnswer((_) async => tFailureResult);
        },
        build: () => sleepTrackingCubit,
        act: (cubit) => cubit.predictSleepQuality(),
        expect: () => [
          const SleepTrackingState.loading(),
          SleepTrackingState.failure(error: tError.message),
        ],
        verify: (_) {
          verify(() =>
                  mockSleepTrackingRepository.predictSleepQuality(tRequestBody))
              .called(1);
        },
      );

      blocTest<SleepTrackingCubit, SleepTrackingState>(
        'emits [failure] immediately if requestBody is null',
        build: () {
          // Ensure requestBody is null
          expect(sleepTrackingCubit.requestBody, isNull);
          return sleepTrackingCubit;
        },
        act: (cubit) => cubit.predictSleepQuality(),
        expect: () => [
          const SleepTrackingState.failure(
              error:
                  'Request body is not set. Please complete the health questions.'),
        ],
        verify: (_) {
          // Verify repository is NOT called
          verifyNever(
              () => mockSleepTrackingRepository.predictSleepQuality(any()));
        },
      );

      blocTest<SleepTrackingCubit, SleepTrackingState>(
        'uses the updated requestBody for prediction',
        setUp: () {
          // Set an initial body, then update it
          sleepTrackingCubit.updateRequestBody(tRequestBody);
          sleepTrackingCubit.updateRequestBody(tRequestBodyUpdated);
          when(() => mockSleepTrackingRepository.predictSleepQuality(
              tRequestBodyUpdated)).thenAnswer((_) async => tSuccessApiResult);
        },
        build: () => sleepTrackingCubit,
        act: (cubit) => cubit.predictSleepQuality(),
        expect: () => [
          // Expect loading state after the last dataUpdated state
          const SleepTrackingState.loading(),
          SleepTrackingState.success(result: tSuccessResult),
        ],
        verify: (_) {
          // Verify it was called with the *updated* body
          verify(() => mockSleepTrackingRepository
              .predictSleepQuality(tRequestBodyUpdated)).called(1);
          // Verify it was NOT called with the old body
          verifyNever(() =>
              mockSleepTrackingRepository.predictSleepQuality(tRequestBody));
        },
      );
    });
  });
}
