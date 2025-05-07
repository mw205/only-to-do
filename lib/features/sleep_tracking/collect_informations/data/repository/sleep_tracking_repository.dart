import 'package:only_to_do/features/sleep_tracking/collect_informations/data/services/sleep_tracking_service.dart';

import '../../../../../core/network/api_result.dart';
import '../models/predict_sleep_quality_request_body.dart';

class SleepTrackingRepository {
  SleepTrackingService service;
  SleepTrackingRepository({required this.service});
  Future<ApiResult<double>> predictSleepQuality(
      PredictSleepQualityRequestBody data) async {
    return await service.predict(data);
  }
}
