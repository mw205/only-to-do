import 'package:dio/dio.dart';

import 'api_error_handler.dart';
import 'api_result.dart';

class ApiCallsHandler {
  Future<ApiResult<T>> handler<T>(
      {required Future<Response> Function() apiCall,
      required T Function(dynamic data) parser}) async {
    try {
      Response response = await apiCall();
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResult.success(parser(response.data));
      } else {
        return ApiResult.failure(
          ApiErrorHandler(
            code: response.statusCode!,
            message: response.statusMessage!,
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ApiErrorHandler.fromDioException(e));
    }
  }
}
