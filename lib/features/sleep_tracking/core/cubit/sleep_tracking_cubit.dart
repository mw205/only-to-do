import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/models/predict_sleep_quality_request_body.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/repository/sleep_tracking_repository.dart';

part 'sleep_tracking_cubit.freezed.dart'; // Ensure this exists or is generated
part 'sleep_tracking_state.dart';

class SleepTrackingCubit extends Cubit<SleepTrackingState> {
  SleepTrackingCubit(this.repository)
      : super(const SleepTrackingState.initial());

  final SleepTrackingRepository repository;

  PredictSleepQualityRequestBody? _requestBody;
  PredictSleepQualityRequestBody? get requestBody => _requestBody;

  void updateRequestBody(PredictSleepQualityRequestBody newRequestBody) {
    _requestBody = newRequestBody;
    emit(SleepTrackingState.dataUpdated(data: _requestBody!));
    // Optionally, you can log here or perform other actions when data is updated
  }

  Future<void> predictSleepQuality() async {
    if (_requestBody == null) {
      emit(const SleepTrackingState.failure(
          error:
              'Request body is not set. Please complete the health questions.'));
      return;
    }
    emit(const SleepTrackingState.loading());

    final result = await repository.predictSleepQuality(_requestBody!);
    result.when(
      success: (data) {
        emit(SleepTrackingState.success(result: data));
      },
      failure: (error) {
        emit(SleepTrackingState.failure(error: error.message));
      },
    );
  }

  // Call this when starting the sleep tracking flow to clear any old data
  void resetSleepTrackingData() {
    _requestBody = null;
    emit(const SleepTrackingState.initial());
  }
}
