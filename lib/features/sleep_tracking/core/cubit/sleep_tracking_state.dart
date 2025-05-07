part of 'sleep_tracking_cubit.dart';

@freezed
class SleepTrackingState with _$SleepTrackingState {
  const factory SleepTrackingState.initial() = _Initial;
  const factory SleepTrackingState.loading() = SleepTrackingDataLoading;
  const factory SleepTrackingState.dataUpdated(
          {required PredictSleepQualityRequestBody data}) =
      SleepTrackingDataUpdated;
  const factory SleepTrackingState.success({required double result}) =
      SleepTrackingSuccess;
  const factory SleepTrackingState.failure({required String error}) =
      SleepTrackingFailure;
}
